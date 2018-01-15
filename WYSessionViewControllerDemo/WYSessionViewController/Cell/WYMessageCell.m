//
//  WYMessageCell.m
//  TrainSkill
//
//  Created by YANGGL on 2018/1/10.
//  Copyright © 2018年 Xwu. All rights reserved.
//

#import "WYMessageCell.h"


@interface WYMessageCell ()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIButton *retryButton;
@property (nonatomic, strong) UILabel *dateTimeLabel;
@property (nonatomic, strong) UIView *statusView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation WYMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.constraints = [NSMutableArray array];
        
        //subview
        [self.contentView addSubview:self.dateTimeLabel];
        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.bubbleImageView];
        [self.contentView addSubview:self.statusView];
        [self.statusView addSubview:self.activityIndicator];
        [self.statusView addSubview:self.retryButton];
        
        //constraints
        [self.dateTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(0);
            make.left.equalTo(self.contentView.mas_left).offset(0);
            make.right.equalTo(self.contentView.mas_right).offset(0);
            make.height.mas_offset(0);
        }];
        
        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dateTimeLabel.mas_bottom).offset(8);
            make.size.mas_offset(CGSizeMake(30, 30));
            SMAS(make.left.equalTo(self.contentView.mas_left).offset(10));
        }];

        [self.bubbleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarImageView.mas_top).offset(0);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-8);
            SMAS(make.left.equalTo(self.avatarImageView.mas_right).offset(7));
            SMAS(make.right.lessThanOrEqualTo(self.contentView.mas_right).offset(-78));
        }];
     
        [self.statusView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.bubbleImageView.mas_centerY).offset(0);
            make.size.mas_offset(CGSizeMake(38, 38));
            SMAS(make.left.equalTo(self.bubbleImageView.mas_right).offset(0));
        }];
        
        [self.activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.statusView.mas_centerY).offset(0);
            make.centerX.equalTo(self.statusView.mas_centerX).offset(0);
            make.size.mas_offset(CGSizeMake(10, 10));
        }];

        [self.retryButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.statusView.mas_centerY).offset(0);
            make.centerX.equalTo(self.statusView.mas_centerX).offset(0);
        }];
    }
    return self;
}

#pragma mark - action

- (void)onTouchRetryAction:(id)sender {
    
}

#pragma mark - private

- (void)updateDirection:(WYMessageDirection)direction {
    for (MASConstraint *constraint in self.constraints) {
        [constraint uninstall];
    }
    
    NSString *bubbleNamed = direction == WYMessageDirection_RECEIVE ? @"WYSession_chat_from_bg_normal" : @"WYSession_chat_to_bg_normal";
    self.bubbleImageView.image = [WYSessionBundleImageNamed(bubbleNamed) stretchableImageWithLeftCapWidth:15 topCapHeight:25];

    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (direction == WYMessageDirection_RECEIVE) {
            SMAS(make.left.equalTo(self.contentView.mas_left).offset(10));
        }else{
            SMAS(make.right.equalTo(self.contentView.mas_right).offset(-10));
        }
    }];
    
    [self.bubbleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (direction == WYMessageDirection_RECEIVE) {
            SMAS(make.left.equalTo(self.avatarImageView.mas_right).offset(7));
            SMAS(make.right.lessThanOrEqualTo(self.contentView.mas_right).offset(-78));
        }else{
            SMAS(make.right.equalTo(self.avatarImageView.mas_left).offset(-7));
            SMAS(make.left.greaterThanOrEqualTo(self.contentView.mas_left).offset(78));
        }
    }];
    
    [self.statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (direction == WYMessageDirection_RECEIVE) {
            SMAS(make.left.equalTo(self.bubbleImageView.mas_right).offset(0));
        }else{
            SMAS(make.right.equalTo(self.bubbleImageView.mas_left).offset(0));
        }
    }];
}

- (void)updateDate:(NSInteger)date showDate:(BOOL)showDate {
    if (!showDate) {
        [self.dateTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(0);
        }];
        return;
    }
    
    [self.dateTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(18);
    }];

    NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:date / 1000];
    self.dateTimeLabel.text = [self.dateFormatter stringFromDate:lastDate];
}

- (void)updateStatus:(WYMessageSendStatus)status {
    if (status == WYMessageSendStatus_SENT) {
        self.retryButton.hidden = YES;
        self.activityIndicator.hidden = YES;
    }
    
    self.retryButton.hidden = status != WYMessageSendStatus_SENT;
    if (status == WYMessageSendStatus_SENDING) {
        [self.activityIndicator startAnimating];
        self.activityIndicator.hidden = NO;
    }
    
    if (status == WYMessageSendStatus_SENT) {
        [self.activityIndicator startAnimating];
        self.activityIndicator.hidden = YES;
    }
    
}

- (void)updateMessage:(WYMessage *)message showDate:(BOOL)showDate {
    self.message = message;
    
    [self updateDirection:message.messageDirection];
    [self updateStatus:message.sentStatus];
    [self updateDate:message.sentTime showDate:showDate];
}

#pragma mark - getter

- (UILabel *)dateTimeLabel {
    if (_dateTimeLabel == nil) {
        _dateTimeLabel = [[UILabel alloc] init];
        _dateTimeLabel.textColor = WYColorFromRGB(0x999999);
        _dateTimeLabel.font = [UIFont systemFontOfSize:9];
        _dateTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _dateTimeLabel;
}

- (UIImageView *)avatarImageView {
    if (_avatarImageView == nil) {
        _avatarImageView = [[UIImageView alloc] initWithImage:WYSessionBundleImageNamed(@"WYSession_chat_from_doctor_icon")];
        _avatarImageView.layer.cornerRadius = 15;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.userInteractionEnabled = YES;
    }
    return _avatarImageView;
}

- (UIImageView *)bubbleImageView {
    if (_bubbleImageView == nil) {
        _bubbleImageView = [[UIImageView alloc] init];
        _bubbleImageView.userInteractionEnabled = YES;
    }
    return _bubbleImageView;
}

- (UIView *)statusView {
    if (_statusView == nil) {
        _statusView = [[UIView alloc] init];
    }
    return _statusView;
}

- (UIButton *)retryButton {
    if (_retryButton == nil) {
        _retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_retryButton setImage:WYSessionBundleImageNamed(@"WYSession_news_failinsend") forState:UIControlStateNormal];
        [_retryButton addTarget:self action:@selector(onTouchRetryAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _retryButton;
}

- (UIActivityIndicatorView *)activityIndicator{
    if (_activityIndicator == nil) {
        _activityIndicator = [[UIActivityIndicatorView alloc] init];
        _activityIndicator.hidesWhenStopped = YES;
        _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        _activityIndicator.color = WYColorFromRGB(0x999999);
    }
    return _activityIndicator;
}

- (NSDateFormatter *)dateFormatter {
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"MM-dd HH:mm:ss";
    }
    return _dateFormatter;
}

@end
