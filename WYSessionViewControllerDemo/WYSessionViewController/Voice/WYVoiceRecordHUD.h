//
//  WYVoiceRecordHUD.h
//  TrainSkill
//
//  Created by YANGGL on 2018/1/11.
//  Copyright © 2018年 Xwu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYVoiceRecordHUD : UIView

+ (void)updatePeakPower:(CGFloat)peakPower;
+ (void)showRecord;
+ (void)showCancel;
+ (void)dismissWithRecordShort;
+ (void)dismiss;

@end
