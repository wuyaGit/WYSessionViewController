//
//  WYMessageCell.h
//  TrainSkill
//
//  Created by YANGGL on 2018/1/10.
//  Copyright © 2018年 Xwu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYMessage.h"
#import "WYSessionMacro.h"

#define SMAS(x) [self.constraints addObject:x]

@interface WYMessageCell : UITableViewCell

@property (nonatomic, strong) WYMessage *message;

@property (nonatomic, strong) UIImageView *bubbleImageView;
@property (nonatomic, strong) NSMutableArray *constraints;

- (void)updateMessage:(WYMessage *)message showDate:(BOOL)showDate;
- (void)updateDirection:(WYMessageDirection)direction;

@end
