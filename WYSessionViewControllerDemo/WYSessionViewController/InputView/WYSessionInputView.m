//
//  WYSessionInputView.m
//  TrainSkill
//
//  Created by YANGGL on 2018/1/10.
//  Copyright © 2018年 Xwu. All rights reserved.
//

#import "WYSessionInputView.h"
#import "WYLocationViewController.h"

#import "WYVoiceRecorder.h"
#import "WYVoiceRecordHUD.h"

#import "WYInputTextView.h"
#import "WYPluginBoardView.h"
#import "WYEmojiBoardView.h"
#import "WYMessage.h"

#import "WYSessionMacro.h"

typedef NS_ENUM(NSInteger, WYBoardViewType) {
    WYBoardViewTypePlugin,
    WYBoardViewTypeEmoji,
    WYBoardViewTypeKey,
    WYBoardViewTypeAll
};

static const NSInteger maxInputTextLength = 300;
static const CGFloat maxInputTextViewHeight = 60.f;
static const CGFloat boardViewHeight = 233.f;
static const CGFloat inputViewHeight = 46.f;
static const CGFloat inputTextViewHeight = 34.f;

@interface WYSessionInputView()<UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, WYPluginBoardViewDelegate, WYPluginBoardViewDataSource, WYEmojiBoardViewDelegate, WYVoiceRecorderDelegate, WYLocationViewControllerDelegate>

@property (nonatomic, strong) UIButton *voiceKeybaordBtn;
@property (nonatomic, strong) UIButton *emojiKeyboardBtn;
@property (nonatomic, strong) UIButton *pluginKeyBoardBtn;
@property (nonatomic, strong) UIButton *sendVoiceBtn;

@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIView *bottomLineView;

@property (nonatomic, strong) WYInputTextView *inputTextView;
@property (nonatomic, strong) WYPluginBoardView *pluginBoardView;
@property (nonatomic, strong) WYEmojiBoardView *emojiBoardView;

@property (nonatomic, strong) WYVoiceRecorder *voiceRecorder;

@property (nonatomic, assign) BOOL keyBoardShow;
@property (nonatomic, assign) BOOL keyBoardHide;
@property (nonatomic, assign) BOOL pluginBoardShow;
@property (nonatomic, assign) BOOL emojiBoardShow;
@property (nonatomic, assign) CGFloat keyBoardHeight;

@end

@implementation WYSessionInputView


#pragma mark - pluginBoardView data source

- (NSArray *)pluginBoardItems {
    return @[[[WYPluginBoardItem alloc] initWithImageNamed:@"WYSession_actionbar_picture_icon"],
             [[WYPluginBoardItem alloc] initWithImageNamed:@"WYSession_actionbar_camera_icon"],
             [[WYPluginBoardItem alloc] initWithImageNamed:@"WYSession_actionbar_location_icon"],
             [[WYPluginBoardItem alloc] initWithImageNamed:@"WYSession_actionbar_audio_icon"],
             [[WYPluginBoardItem alloc] initWithImageNamed:@"WYSession_actionbar_file_icon"],
             [[WYPluginBoardItem alloc] initWithImageNamed:@"WYSession_actionbar_video_icon"]];
}

#pragma mark - pluginBoardView delegate

- (void)pluginBoardDidClickItem:(NSInteger)index {
    switch (index) {
        case 0:
            [self presentImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            break;
        case 1:
            [self presentImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypeCamera];
            break;
        case 2:
            [self presentLocationViewController];
            break;
        default:
            break;
    }
}

#pragma mark - emojiBoardView delegate

- (void)emojiBoardViewDidSeletedEmoji:(NSString *)emoji {
    NSMutableString *text = [self.inputTextView.text mutableCopy];
    [text appendString:emoji];
    
//    self.inputTextView.text = text.length > maxInputTextLength ? [text substringWithRange:NSMakeRange(0, maxInputTextLength)] : [text copy];
    self.inputTextView.text = [text copy];

    [self updateConstraintsWithInputTextChanged:boardViewHeight];
}

- (void)emojiBoardViewDidBackspace {
    [self.inputTextView deleteBackward];
    
    [self updateConstraintsWithInputTextChanged:boardViewHeight];
}

- (void)emojiBoardViewDidSend {
    NSString *text = self.inputTextView.text;
    if ([text isEqualToString:@""] || !text) {
        return;
    }
    
    self.inputTextView.text = @"";
    [self.inputTextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(inputTextViewHeight);
    }];
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(inputViewHeight);
    }];
    
    [self inputTextViewResignFirstResponder];
    
    WYMessageContent *content = [WYTextMessage messageWithContent:text];
    [self sendMessage:content];
}

#pragma mark - voiceRecorder delegate

- (void)recoredVoiceCompletionWithVoiceData:(NSData *)data duration:(long)duration {
    WYMessageContent *content = [WYVoiceMessage messageWithAudio:data duration:duration];
    [self sendMessage:content];
}

#pragma mark - location view delegate

- (void)locationViewSendMessage:(WYLocationMessage *)content {
    [self sendMessage:content];
}

#pragma mark - imagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    WYMessageContent *content = [WYImageMessage messageWithImage:image];
    [self sendMessage:content];
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - navigationController Delegate
// 解决导航栏透明
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(nonnull UIViewController *)viewController animated:(BOOL)animated {
    if ([navigationController isKindOfClass:[UIImagePickerController class]]){
        viewController.navigationController.navigationBar.translucent = NO;
        viewController.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - textView delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        
        [self emojiBoardViewDidSend];
        return NO;
    }
    
    [self updateConstraintsWithInputTextChanged:self.keyBoardHeight];

    return YES;
}

#pragma mark - keyboardWillShow notification

- (void)keyboardDidChange:(NSNotification *)notification  {
    CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    self.keyBoardHeight = keyboardRect.size.height;

    if (!self.keyBoardHide) {
        [self boardViewDidChanged:WYBoardViewTypeKey height:keyboardRect.size.height];
    }
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    self.keyBoardHeight = keyboardRect.size.height;
    self.keyBoardHide = NO;

    [self boardViewDidChanged:WYBoardViewTypeKey height:keyboardRect.size.height];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.keyBoardHide = YES;
    
    [self boardViewDidChanged:WYBoardViewTypeAll height:boardViewHeight];
}

#pragma mark - initializer

- (instancetype)init {
    if (self = [super init]) {
        
        self.backgroundColor = WYColorFromRGB(0xF4F4F4);

        //subview
        [self addSubview:self.voiceKeybaordBtn];
        [self addSubview:self.emojiKeyboardBtn];
        [self addSubview:self.pluginKeyBoardBtn];
        [self addSubview:self.inputTextView];
        [self addSubview:self.sendVoiceBtn];
        [self addSubview:self.topLineView];
        [self addSubview:self.bottomLineView];
        [self addSubview:self.pluginBoardView];
        [self addSubview:self.emojiBoardView];

        //constraints
        [self.voiceKeybaordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(6);
            make.top.equalTo(self.mas_top).offset(6);
            make.size.mas_equalTo(CGSizeMake(34, 34));
        }];
        
        [self.inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.voiceKeybaordBtn.mas_right).offset(6);
            make.top.equalTo(self.mas_top).offset(6);
            make.height.mas_offset(inputTextViewHeight);
        }];
        
        [self.sendVoiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.voiceKeybaordBtn.mas_right).offset(6);
            make.top.equalTo(self.mas_top).offset(6);
            make.bottom.equalTo(self.inputTextView.mas_bottom).offset(0);
            make.width.equalTo(self.inputTextView.mas_width).offset(0);
        }];
        
        [self.emojiKeyboardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.inputTextView.mas_right).offset(6);
            make.centerY.equalTo(self.voiceKeybaordBtn.mas_centerY);
            make.size.mas_offset(CGSizeMake(34, 34));
        }];
        
        [self.pluginKeyBoardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.emojiKeyboardBtn.mas_right).offset(6);
            make.right.equalTo(self.mas_right).offset(-6);
            make.centerY.equalTo(self.voiceKeybaordBtn.mas_centerY);
            make.size.mas_offset(CGSizeMake(34, 34));
        }];
        
        [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(0);
            make.right.equalTo(self.mas_right).offset(0);
            make.top.equalTo(self.mas_top).offset(0);
            make.height.mas_offset(@0.5);
        }];
        
        [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(0);
            make.right.equalTo(self.mas_right).offset(0);
            make.top.equalTo(self.inputTextView.mas_bottom).offset(5);
            make.height.mas_offset(@0.5);
        }];

        [self.pluginBoardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(0);
            make.right.equalTo(self.mas_right).offset(0);
            make.top.equalTo(self.bottomLineView.mas_bottom).offset(0);
            make.height.mas_offset(boardViewHeight);
        }];
        
        [self.emojiBoardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(0);
            make.right.equalTo(self.mas_right).offset(0);
            make.top.equalTo(self.bottomLineView.mas_bottom).offset(0);
            make.height.mas_offset(boardViewHeight);
        }];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardDidChange:)
                                                     name:UIKeyboardDidChangeFrameNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];

    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - touch methods

- (void)onTouchVoiceAction:(id)sender {
    UIButton *button = sender;
    button.selected = !button.selected;
    
    self.emojiKeyboardBtn.selected = NO;
    self.sendVoiceBtn.hidden = !button.selected;
    if (button.selected) {
        [self inputTextViewResignFirstResponder];
        [self boardViewDidChanged:WYBoardViewTypeAll height:boardViewHeight];
    }else {
        [self inputTextViewBecomeFirstResponder];
    }
}

- (void)onTouchEmojiAction:(id)sender {
    UIButton *button = sender;
    button.selected = !button.selected;
    
    self.pluginKeyBoardBtn.selected = NO;
    self.voiceKeybaordBtn.selected = NO;
    self.sendVoiceBtn.hidden = YES;

    if (button.selected) {
        [self boardViewDidChanged:WYBoardViewTypeEmoji height:boardViewHeight];
    }else {
        [self inputTextViewBecomeFirstResponder];
    }
}

- (void)onTouchPluginAction:(id)sender {
    UIButton *button = sender;
    button.selected = !button.selected;
    
    self.emojiKeyboardBtn.selected = NO;
    self.voiceKeybaordBtn.selected = NO;
    self.sendVoiceBtn.hidden = YES;

    [self boardViewDidChanged:WYBoardViewTypePlugin height:boardViewHeight];
}

- (void)onTouchSendVoiceBeginRecord:(UIButton *)sender {
    [self.voiceRecorder startRecord];
    sender.backgroundColor = WYColorFromRGB(0x333333);

}

- (void)onTouchSendVoiceEndRecord:(UIButton *)sender {
    [self.voiceRecorder competionRecord];
    sender.backgroundColor = WYColorFromRGB(0xdddddd);

}

- (void)onTouchSendVoiceCancelRecord:(UIButton *)sender {
    [self.voiceRecorder cancelRecord];
    sender.backgroundColor = WYColorFromRGB(0xdddddd);

}

- (void)onTouchSendVoiceRemindDragExit:(UIButton *)sender {
    [WYVoiceRecordHUD showCancel];
    sender.backgroundColor = WYColorFromRGB(0xdddddd);

}

- (void)onTouchSendVoiceRemindDragEnter:(UIButton *)sender {
    [WYVoiceRecordHUD showRecord];
    sender.backgroundColor = WYColorFromRGB(0x333333);
}

#pragma mark - private

- (void)boardViewDidChanged:(WYBoardViewType)boardType height:(CGFloat)height {
    switch (boardType) {
        case WYBoardViewTypePlugin: {
            self.pluginBoardShow = !self.pluginBoardShow;
            self.emojiBoardShow = NO;
            self.keyBoardShow = NO;
            
            [self inputTextViewResignFirstResponder];
        }
            break;
            
        case WYBoardViewTypeEmoji: {
            self.pluginBoardShow = NO;
            self.emojiBoardShow = !self.emojiBoardShow;
            self.keyBoardShow = NO;
            
            [self inputTextViewResignFirstResponder];
        }
            break;
            
        case WYBoardViewTypeKey: {
            self.pluginBoardShow = NO;
            self.emojiBoardShow = NO;
            self.keyBoardShow = YES;
        }
            break;
        case WYBoardViewTypeAll: {
            self.pluginBoardShow = NO;
            self.emojiBoardShow = NO;
            self.keyBoardShow = NO;
        }
            break;
    }
    
    BOOL showBoard = self.pluginBoardShow || self.emojiBoardShow || self.keyBoardShow;
    
    CGFloat inputHeight = inputViewHeight;
    if (self.inputTextView.contentSize.height > inputViewHeight) {
        inputHeight = inputViewHeight + self.inputTextView.contentSize.height - inputTextViewHeight;
    }
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(showBoard ? height + inputHeight : inputHeight);
    }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputViewHeightChanged:)]) {
        [self.delegate inputViewHeightChanged:(showBoard ? height + inputHeight : inputHeight)];
    }
}

- (void)inputTextViewResignFirstResponder {
    if (self.inputTextView.isFirstResponder) {
        [self.inputTextView resignFirstResponder];
    }
}

- (void)inputTextViewBecomeFirstResponder {
    if (!self.inputTextView.isFirstResponder) {
        [self.inputTextView becomeFirstResponder];
    }
}

- (void)updateConstraintsWithInputTextChanged:(CGFloat)height  {
    if (self.inputTextView.contentSize.height > inputViewHeight) {
        [self.inputTextView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.inputTextView.contentSize.height);
        }];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(inputViewHeight + self.inputTextView.contentSize.height - inputTextViewHeight + height);
        }];
    }else {
        [self.inputTextView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(inputTextViewHeight);
        }];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(inputViewHeight + height);
        }];
    }
    
//    if (self.delegate && [self.delegate respondsToSelector:@selector(inputViewHeightChanged:)]) {
//        [self.delegate inputViewHeightChanged:(showBoard ? height + inputHeight : inputHeight)];
//    }

}

- (void)presentImagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        picker.delegate = self;
        
        [(UIViewController *)self.delegate presentViewController:picker animated:YES completion:nil];
    }
}

- (void)presentLocationViewController {
    WYLocationViewController *locationViewController = [[WYLocationViewController alloc] init];
    locationViewController.delegate = self;
    UINavigationController *locationNav = [[UINavigationController alloc] initWithRootViewController:locationViewController];
    locationNav.navigationBar.translucent = NO;
    [(UIViewController *)self.delegate presentViewController:locationNav animated:YES completion:nil];
}

- (void)sendMessage:(WYMessageContent *)content {
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputViewSendMessage:)]) {
        WYUserInfo *userInfo = [[WYUserInfo alloc] initWithUserId:@"1002" name:@"明仔" portrait:@""];
        WYMessage *message = [[WYMessage alloc] initWithType:WYConversationType_PRIVATE
                                                    targetId:@"111"
                                                   direction:WYMessageDirection_SEND
                                                   messageId:123
                                                    userInfo:userInfo
                                                     content:content];

        [self.delegate inputViewSendMessage:message];
    }
}

- (void)hideAllKeyboard {
//    if (self.lastContentOffset != inputViewHeight) {
        [self inputTextViewResignFirstResponder];
        [self boardViewDidChanged:WYBoardViewTypeAll height:boardViewHeight];
        
        self.emojiKeyboardBtn.selected = NO;
//    }
}

#pragma mark - getter

- (UIButton *)voiceKeybaordBtn {
    if (_voiceKeybaordBtn == nil) {
        _voiceKeybaordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_voiceKeybaordBtn setImage:WYSessionBundleImageNamed(@"WYSession_chatbar_voice_icon") forState:UIControlStateNormal];
        [_voiceKeybaordBtn setImage:WYSessionBundleImageNamed(@"WYSession_chatbar_kyb_icon") forState:UIControlStateSelected];
        [_voiceKeybaordBtn addTarget:self action:@selector(onTouchVoiceAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceKeybaordBtn;
}

- (UIButton *)emojiKeyboardBtn {
    if (_emojiKeyboardBtn == nil) {
        _emojiKeyboardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_emojiKeyboardBtn setImage:WYSessionBundleImageNamed(@"WYSession_chatbar_face_icon") forState:UIControlStateNormal];
        [_emojiKeyboardBtn setImage:WYSessionBundleImageNamed(@"WYSession_chatbar_kyb_icon") forState:UIControlStateSelected];
        [_emojiKeyboardBtn addTarget:self action:@selector(onTouchEmojiAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _emojiKeyboardBtn;
}

- (UIButton *)pluginKeyBoardBtn {
    if (_pluginKeyBoardBtn == nil) {
        _pluginKeyBoardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pluginKeyBoardBtn setImage:WYSessionBundleImageNamed(@"WYSession_chatbar_add_icon") forState:UIControlStateNormal];
        [_pluginKeyBoardBtn addTarget:self action:@selector(onTouchPluginAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pluginKeyBoardBtn;
}

- (UIButton *)sendVoiceBtn {
    if (_sendVoiceBtn == nil) {
        _sendVoiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendVoiceBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
        [_sendVoiceBtn setTitleColor:WYColorFromRGB(0x999999) forState:UIControlStateNormal];
        [_sendVoiceBtn setBackgroundColor:WYColorFromRGB(0xdddddd)];
        [_sendVoiceBtn addTarget:self action:@selector(onTouchSendVoiceBeginRecord:) forControlEvents:UIControlEventTouchDown];
        [_sendVoiceBtn addTarget:self action:@selector(onTouchSendVoiceEndRecord:) forControlEvents:UIControlEventTouchUpInside];
        [_sendVoiceBtn addTarget:self action:@selector(onTouchSendVoiceCancelRecord:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel];
        [_sendVoiceBtn addTarget:self action:@selector(onTouchSendVoiceRemindDragExit:) forControlEvents:UIControlEventTouchDragExit];
        [_sendVoiceBtn addTarget:self action:@selector(onTouchSendVoiceRemindDragEnter:) forControlEvents:UIControlEventTouchDragEnter];

        _sendVoiceBtn.layer.cornerRadius = 4.0f;
        _sendVoiceBtn.layer.borderColor = WYColorFromRGB(0xcccccc).CGColor;
        _sendVoiceBtn.layer.borderWidth = 0.5;
        _sendVoiceBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _sendVoiceBtn.hidden = YES;

    }
    return _sendVoiceBtn;
}


- (WYInputTextView *)inputTextView {
    if (_inputTextView == nil) {
        _inputTextView = [[WYInputTextView alloc] init];
        _inputTextView.font = [UIFont systemFontOfSize:13];
        _inputTextView.tintColor = WYColorFromRGB(0x999999);
        _inputTextView.returnKeyType = UIReturnKeySend;
        _inputTextView.delegate = self;
        _inputTextView.layer.cornerRadius = 4.0f;
        _inputTextView.layer.borderColor = WYColorFromRGB(0xcccccc).CGColor;
        _inputTextView.layer.borderWidth = 0.5;
        _inputTextView.placeholderText = @"聊点什么吧";
        _inputTextView.placeholderColor = WYColorFromRGB(0x999999);
        _inputTextView.maxTextViewHeight = maxInputTextViewHeight;
        [_inputTextView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _inputTextView;
}

- (WYPluginBoardView *)pluginBoardView {
    if (_pluginBoardView == nil) {
        _pluginBoardView = [[WYPluginBoardView alloc] init];
        _pluginBoardView.delegate = self;
        _pluginBoardView.dataSource = self;
    }
    return _pluginBoardView;
}

- (WYEmojiBoardView *)emojiBoardView {
    if (_emojiBoardView == nil) {
        _emojiBoardView = [[WYEmojiBoardView alloc] init];
        _emojiBoardView.delegate = self;
    }
    return _emojiBoardView;
}

- (UIView *)topLineView {
    if (_topLineView == nil) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = WYColorFromRGB(0xcccccc);
    }
    return _topLineView;
}

- (UIView *)bottomLineView {
    if (_bottomLineView == nil) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = WYColorFromRGB(0xcccccc);
    }
    return _bottomLineView;
}

- (WYVoiceRecorder *)voiceRecorder {
    if (_voiceRecorder == nil) {
        _voiceRecorder = [[WYVoiceRecorder alloc] init];
        _voiceRecorder.delegate = self;
    }
    return _voiceRecorder;
}

#pragma mark - setter

- (void)setPluginBoardShow:(BOOL)pluginBoardShow {
    _pluginBoardShow = pluginBoardShow;
    
    self.pluginBoardView.hidden = !pluginBoardShow;
}

- (void)setEmojiBoardShow:(BOOL)emojiBoardShow {
    _emojiBoardShow = emojiBoardShow;
    
    self.emojiBoardView.hidden = !emojiBoardShow;
}

@end
