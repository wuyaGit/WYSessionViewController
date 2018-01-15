//
//  WYEmojiBoardView.m
//  TrainSkill
//
//  Created by YANGGL on 2018/1/10.
//  Copyright © 2018年 Xwu. All rights reserved.
//

#import "WYEmojiBoardView.h"
#import "WYSessionMacro.h"

@interface WYEmojiBoardView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *sendButton;


@property (nonatomic, strong) NSArray *emojiArray;
@end

@implementation WYEmojiBoardView {
    BOOL hasLayout;
}

#pragma mark - scrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControl.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
}

#pragma mark - initializer

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = WYColorFromRGB(0xEAEAEA);
        
        // addsubview
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
        [self addSubview:self.bottomView];
        [self.bottomView addSubview:self.sendButton];
        
        //Constraints
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(0);
            make.right.equalTo(self.mas_right).offset(0);
            make.top.equalTo(self.mas_top).offset(0);
        }];
        
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(0);
            make.right.equalTo(self.mas_right).offset(0);
            make.top.equalTo(self.scrollView.mas_bottom).offset(0);
            make.bottom.equalTo(self.mas_bottom).offset(0);
            make.height.mas_offset(@37);
        }];
        
        [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX).offset(0);
            make.bottom.equalTo(self.scrollView.mas_bottom).offset(0);
            make.width.mas_offset(@26);
        }];
        
        [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.bottomView.mas_right).offset(0);
            make.top.equalTo(self.bottomView.mas_top).offset(0);
            make.bottom.equalTo(self.bottomView.mas_bottom).offset(0);
            make.width.mas_offset(@50);
        }];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (hasLayout) {
        return;
    }
    hasLayout = YES;
    [self.scrollView setContentSize:CGSizeMake(self.emojiArray.count * self.frame.size.width, self.scrollView.frame.size.height)];
    [self.pageControl setNumberOfPages:self.emojiArray.count];
    
    CGSize emojiSize = CGSizeMake(36, 34);
    CGFloat spacingWidth = (self.scrollView.frame.size.width - emojiSize.width * 8) / 9;
    CGFloat spacingHeight = (self.scrollView.frame.size.height - self.pageControl.frame.size.height - emojiSize.height * 3) / 4;

    for (NSInteger i = 0; i < self.emojiArray.count; i++) {
        UIView *pageView = [[UIView alloc] init];
        pageView.frame = CGRectMake(i * self.frame.size.width, 0, self.frame.size.width, self.scrollView.frame.size.height - self.pageControl.frame.size.height);
        [self.scrollView addSubview:pageView];
        
        NSArray *emojis = self.emojiArray[i];
        for (NSInteger j = 0; j < emojis.count; j++) {
            NSInteger idxW = j % 8;
            NSInteger idxH = (j / 8) % 3;

            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:emojis[j] forState:UIControlStateNormal];
            [button setFrame: CGRectMake(spacingWidth * (idxW + 1) + idxW * emojiSize.width , spacingHeight * (idxH + 1) + idxH * emojiSize.height, emojiSize.width, emojiSize.height)];
            [button addTarget:self action:@selector(onTouchSeletedEmoji:) forControlEvents:UIControlEventTouchUpInside];
            [pageView addSubview:button];
            
            if (j == emojis.count - 1) {
                button.imageView.contentMode = UIViewContentModeScaleAspectFit;
                [button setImage:WYSessionBundleImageNamed(@"WYSession_emoji_btn_delete") forState:UIControlStateNormal];
            }
        }
    }
    
}

- (void)onTouchSeletedEmoji:(id)sender {
    UIButton *button = sender;
    if (button.titleLabel.text.length) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(emojiBoardViewDidSeletedEmoji:)]) {
            [self.delegate emojiBoardViewDidSeletedEmoji:button.titleLabel.text];
        }
    }else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(emojiBoardViewDidBackspace)]) {
            [self.delegate emojiBoardViewDidBackspace];
        }
    }
}

- (void)onTouchClickSend:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(emojiBoardViewDidSend)]) {
        [self.delegate emojiBoardViewDidSend];
    }
}

#pragma mark - getter

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.backgroundColor = WYColorFromRGB(0xf8f8f8);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.currentPageIndicatorTintColor = WYColorFromRGB(0x888888);
        _pageControl.pageIndicatorTintColor = WYColorFromRGB(0xb9b9b9);
    }
    return _pageControl;
}

- (UIView *)bottomView {
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = WYColorFromRGB(0xffffff);
    }
    return _bottomView;
}

- (UIButton *)sendButton {
    if (_sendButton == nil) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:WYColorFromRGB(0x9d9d9d) forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _sendButton.backgroundColor = WYColorFromRGB(0xf8f8f8);
        [_sendButton addTarget:self action:@selector(onTouchClickSend:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

- (NSArray *)emojiArray {
    if (_emojiArray == nil) {
        _emojiArray = @[
  @[@"😊",@"😨",@"😍",@"😳",@"😎",@"😭",@"😌",@"😵",@"😴",@"😢",@"😅",@"😡",@"😜",@"😀",@"😲",@"😟",@"😤",@"😞",@"😫",@"😣",@"😈",@"😉",@"😯",@""],
  @[@"😕",@"😰",@"😋",@"😝",@"😓",@"😀",@"😂",@"😘",@"😒",@"😏",@"😶",@"😱",@"😖",@"😩",@"😔",@"😑",@"😚",@"😪",@"😇",@"🙊",@"👊",@"👎",@"☝️",@""],
  @[@"✌️",@"😬",@"😷",@"🙈",@"👌",@"👋",@"✊",@"💪",@"😆",@"☺️",@"🙉",@"👍",@"🙏",@"✋",@"☀️",@"☕️",@"⛄️",@"📚",@"🎁",@"🎉",@"🍦",@"☁️",@"❄️",@""],
  @[@"⚡️",@"💰",@"🎂",@"🎓",@"🍖",@"☔️",@"⛅️",@"✏️",@"💩",@"🎄",@"🍷",@"🎤",@"🏀",@"🀄️",@"💣",@"📢",@"🌍",@"🍫",@"🎲",@"🏂",@"💡",@"💤",@"🚫",@""],
  @[@"🌻",@"🍻",@"🎵",@"🏡",@"💢",@"📞",@"🚿",@"🍚",@"👪",@"👼",@"💊",@"🔫",@"🌹",@"🐶",@"💄",@"👫",@"👽",@"💋",@"🌙",@"🍉",@"🐷",@"💔",@"👻",@""],
  @[@"😈",@"💍",@"🌲",@"🐴",@"👑",@"🔥",@"⭐️",@"⚽️",@"🕖",@"⏰",@"😁",@"🚀",@"⏳",@""]];
    }
    return _emojiArray;
}

@end
