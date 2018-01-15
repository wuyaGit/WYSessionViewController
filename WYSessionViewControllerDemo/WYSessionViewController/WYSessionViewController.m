//
//  WYSessionViewController.m
//  TrainSkill
//
//  Created by YANGGL on 2017/12/14.
//  Copyright © 2017年 Xwu. All rights reserved.
//

#import "WYSessionViewController.h"
#import "WYSessionInputView.h"
#import "WYMessageCell.h"
#import "WYTextMessageCell.h"
#import "WYVoiceMessageCell.h"
#import "WYImageMessageCell.h"
#import "WYLocationMessageCell.h"

#import "WYMessage.h"

#import "WYSessionMacro.h"

@interface WYSessionViewController ()<UITableViewDelegate, UITableViewDataSource, WYSessionInputViewDelegate>

@property (nonatomic, strong) UITableView *chatTableView;
@property (nonatomic, strong) WYSessionInputView *inputView;
@property (nonatomic, strong) NSMutableArray *messages;

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation WYSessionViewController

#pragma mark - Table view datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WYMessage *message = self.messages[indexPath.row];
    WYMessage *lastMsg = self.messages[0];

    WYMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:[self cellIdentifierWithMessage:message]];
    [cell updateMessage:message showDate:(message.sentTime - lastMsg.sentTime > 60 * 5 * 1000)];
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WYMessage *message = self.messages[indexPath.row];
    WYMessage *lastMsg = self.messages[0];
        
    CGFloat height = [tableView fd_heightForCellWithIdentifier:[self cellIdentifierWithMessage:message] cacheByIndexPath:indexPath configuration:^(WYMessageCell *cell) {
        [(WYMessageCell *)cell updateMessage:message showDate:(message.sentTime - lastMsg.sentTime > 60 * 5 * 1000)];
    }];
    return height;
}

#pragma mark - sessionInputView delegate

- (void)inputViewSendMessage:(WYMessage *)message {
    [self.messages addObject:message];

    [self.chatTableView reloadData];
    [self scrollToBottom];
}

- (void)inputViewHeightChanged:(CGFloat)offset {
    [self scrollToBottom:self.view.frame.size.height - offset];
}

#pragma mark - Cycle life

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self scrollToBottom];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.chatTableView];
    [self.view addSubview:self.inputView];
    
    [self.chatTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(0);
        make.bottom.equalTo(self.inputView.mas_top).offset(0);
    }];
    
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.height.mas_offset(@46);
    }];
    
    [self setupMessages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupMessages {
    WYMessage *msg1 = [WYMessage messageWithType:WYConversationType_PRIVATE
                                        targetId:@"1"
                                       direction:WYMessageDirection_SEND
                                       messageId:12
                                        userInfo:[[WYUserInfo alloc] initWithUserId:@"1" name:@"mz" portrait:@""]
                                         content:[WYTextMessage messageWithContent:@"你好"]];
    [self.messages addObject:msg1];
    
    WYMessage *msg2 = [WYMessage messageWithType:WYConversationType_PRIVATE
                                             targetId:@"1"
                                            direction:WYMessageDirection_RECEIVE
                                            messageId:12
                                             userInfo:[[WYUserInfo alloc] initWithUserId:@"1" name:@"mz" portrait:@""]
                                              content:[WYTextMessage messageWithContent:@"你好"]];
    [self.messages addObject:msg2];

    WYMessage *msg3 = [WYMessage messageWithType:WYConversationType_PRIVATE
                                        targetId:@"1"
                                       direction:WYMessageDirection_SEND
                                       messageId:12
                                        userInfo:[[WYUserInfo alloc] initWithUserId:@"1" name:@"mz" portrait:@""]
                                         content:[WYTextMessage messageWithContent:@"你好"]];
    [self.messages addObject:msg3];

    WYMessage *msg4 = [WYMessage messageWithType:WYConversationType_PRIVATE
                                        targetId:@"1"
                                       direction:WYMessageDirection_SEND
                                       messageId:12
                                        userInfo:[[WYUserInfo alloc] initWithUserId:@"1" name:@"mz" portrait:@""]
                                         content:[WYTextMessage messageWithContent:@"这一套缓存机制能对滑动起多大影响呢？除了肉眼能明显的感知到外，我还做了个小测试"]];
    [self.messages addObject:msg4];

    WYMessage *msg5 = [WYMessage messageWithType:WYConversationType_PRIVATE
                                        targetId:@"1"
                                       direction:WYMessageDirection_RECEIVE
                                       messageId:12
                                        userInfo:[[WYUserInfo alloc] initWithUserId:@"1" name:@"mz" portrait:@""]
                                         content:[WYTextMessage messageWithContent:@"你好"]];
    [self.messages addObject:msg5];

    WYMessage *msg6 = [WYMessage messageWithType:WYConversationType_PRIVATE
                                        targetId:@"1"
                                       direction:WYMessageDirection_RECEIVE
                                       messageId:12
                                        userInfo:[[WYUserInfo alloc] initWithUserId:@"1" name:@"mz" portrait:@""]
                                         content:[WYImageMessage messageWithImage:WYSessionBundleImageNamed(@"WYSession_chat_default_image")]];
    [self.messages addObject:msg6];

    WYMessage *msg7 = [WYMessage messageWithType:WYConversationType_PRIVATE
                                        targetId:@"1"
                                       direction:WYMessageDirection_SEND
                                       messageId:12
                                        userInfo:[[WYUserInfo alloc] initWithUserId:@"1" name:@"mz" portrait:@""]
                                         content:[WYTextMessage messageWithContent:@"你好"]];
    [self.messages addObject:msg7];

    WYMessage *msg8 = [WYMessage messageWithType:WYConversationType_PRIVATE
                                        targetId:@"1"
                                       direction:WYMessageDirection_SEND
                                       messageId:12
                                        userInfo:[[WYUserInfo alloc] initWithUserId:@"1" name:@"mz" portrait:@""]
                                         content:[WYTextMessage messageWithContent:@"你好"]];
    [self.messages addObject:msg8];

    WYMessage *msg9 = [WYMessage messageWithType:WYConversationType_PRIVATE
                                        targetId:@"1"
                                       direction:WYMessageDirection_RECEIVE
                                       messageId:12
                                        userInfo:[[WYUserInfo alloc] initWithUserId:@"1" name:@"mz" portrait:@""]
                                         content:[WYTextMessage messageWithContent:@"你好"]];
    [self.messages addObject:msg9];

    [self.chatTableView reloadData];
}

#pragma mark - Private methods

- (NSString *)cellIdentifierWithMessage:(WYMessage *)message {
    NSDictionary *tmpDict = @{@"WYTextMessage": @"textcell", @"WYVoiceMessage": @"voicecell", @"WYImageMessage": @"photocell", @"WYLocationMessage": @"locationcell"};
    
    return tmpDict[NSStringFromClass([message.content class])];
}

- (NSIndexPath *)lastMessageIndexPath{
    if (self.messages.count) {
        return [NSIndexPath indexPathForItem:self.messages.count - 1 inSection:0];
    }else {
        return nil;
    }
}

- (void)scrollToBottom:(CGFloat)offset {
    if (self.messages.count) {
        [UIView animateWithDuration:0.25 animations:^{
            CGFloat yOffset = self.chatTableView.contentSize.height - offset;
            [self.chatTableView setContentOffset:CGPointMake(0, yOffset) animated:NO];
        }];
    }
}

- (void)scrollToBottom {
    if (self.messages.count) {
        [UIView animateWithDuration:0.25 animations:^{
            CGFloat yOffset = 0; //设置要滚动的位置 0最顶部 CGFLOAT_MAX最底部
            if (self.chatTableView.contentSize.height > self.chatTableView.bounds.size.height) {
                yOffset = self.chatTableView.contentSize.height - self.chatTableView.bounds.size.height;
            }
            [self.chatTableView setContentOffset:CGPointMake(0, yOffset) animated:NO];
        }];
    }
}

- (void)hideInputViewKeyboard:(id)sender {
    [self.inputView hideAllKeyboard];
}

#pragma mark - Getter

- (UITableView *)chatTableView {
    if (!_chatTableView) {
        _chatTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _chatTableView.delegate = self;
        _chatTableView.dataSource = self;
        _chatTableView.backgroundColor = WYColorFromRGB(0xebebeb);
        _chatTableView.backgroundColor = WYColorFromRGB(0xf8f8f8);
        _chatTableView.separatorColor = WYColorFromRGB(0xeeeeee);
        _chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _chatTableView.rowHeight = UITableViewAutomaticDimension;
        _chatTableView.estimatedRowHeight = 50;

        [_chatTableView registerClass:[WYTextMessageCell class] forCellReuseIdentifier:@"textcell"];
        [_chatTableView registerClass:[WYImageMessageCell class] forCellReuseIdentifier:@"photocell"];
        [_chatTableView registerClass:[WYVoiceMessageCell class] forCellReuseIdentifier:@"voicecell"];
        [_chatTableView registerClass:[WYLocationMessageCell class] forCellReuseIdentifier:@"locationcell"];
    }
    return _chatTableView;
}

- (WYSessionInputView *)inputView {
    if (!_inputView) {
        _inputView = [[WYSessionInputView alloc] init];
        _inputView.delegate = self;
    }
    return _inputView;
}

- (NSMutableArray *)messages {
    if (!_messages) {
        _messages = [NSMutableArray array];
    }
    return _messages;
}

- (UITapGestureRecognizer *)tapGestureRecognizer {
    if (!_tapGestureRecognizer) {
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideInputViewKeyboard:)];
        _tapGestureRecognizer.cancelsTouchesInView = NO;
    }
    return _tapGestureRecognizer;
}


@end
