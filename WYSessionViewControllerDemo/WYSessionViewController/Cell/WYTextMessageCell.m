//
//  WYTextMessageCell.m
//  TrainSkill
//
//  Created by YANGGL on 2018/1/11.
//  Copyright © 2018年 Xwu. All rights reserved.
//

#import "WYTextMessageCell.h"

@interface WYTextMessageCell ()

@property (nonatomic, strong) UILabel *messageLabel;
@end


@implementation WYTextMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //
        [self.bubbleImageView addSubview:self.messageLabel];
        
        //
        [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_offset(UIEdgeInsetsMake(10, 15, 10, 15));
        }];
    }
    return self;
}

- (void)updateDirection:(WYMessageDirection)direction {
    [super updateDirection:direction];
    
    [self.messageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        if (direction == WYMessageDirection_RECEIVE) {
            make.edges.mas_offset(UIEdgeInsetsMake(10, 15, 10, 10));
        }else{
            make.edges.mas_offset(UIEdgeInsetsMake(10, 10, 10, 15));
        }
    }];
}

- (void)updateMessage:(WYMessage *)message showDate:(BOOL)showDate {
    [super updateMessage:message showDate:showDate];
    
    WYTextMessage *textMessage = (WYTextMessage *)message.content;
    self.messageLabel.text = textMessage.content;
}

#pragma mark - getter

- (UILabel *)messageLabel{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.font = [UIFont systemFontOfSize:15];
        _messageLabel.textColor = WYColorFromRGB(0x333333);
        _messageLabel.numberOfLines = 0;
    }
    return _messageLabel;
}


@end
