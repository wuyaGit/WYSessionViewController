//
//  WYVoiceRecordHUD.m
//  TrainSkill
//
//  Created by YANGGL on 2018/1/11.
//  Copyright © 2018年 Xwu. All rights reserved.
//

#import "WYVoiceRecordHUD.h"
#import "WYSessionMacro.h"

#define kApplicationKeyWindow [UIApplication sharedApplication].keyWindow

@interface WYVoiceRecordHUD ()

@property (nonatomic, strong) UIImageView *recordTipImage;
@property (nonatomic, strong) UIButton *statusButton;

@property (nonatomic, strong) NSDictionary *animationDic;
@end

@implementation WYVoiceRecordHUD

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = WYColorFromRGBA(0x000000, 0.5);
        self.layer.cornerRadius = 4.f;
        self.tag = 911;
        
        //
        [self addSubview:self.recordTipImage];
        [self addSubview:self.statusButton];
        
        //
        [self.recordTipImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(20);
            make.centerX.equalTo(self.mas_centerX).offset(0);
            make.size.mas_offset(CGSizeMake(90, 90));
        }];
        
        [self.statusButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(7);
            make.right.equalTo(self.mas_right).offset(-7);
            make.bottom.equalTo(self.mas_bottom).offset(-7);
            make.height.mas_offset(22);
        }];
        
    }
    return self;
}

#pragma mark - private

- (void)updatePeakPower:(CGFloat)peakPower {
    NSString *value ;
    for (NSArray *keys in self.animationDic) {
        if (peakPower < [keys[1] floatValue] && peakPower > [keys[0] floatValue]) {
            value = self.animationDic[keys];
            break;
        }
    }
    
    if (value.length) {
        self.recordTipImage.image = WYSessionBundleImageNamed(value);
    }
}

#pragma mark - public

+ (void)updatePeakPower:(CGFloat)peakPower {
    WYVoiceRecordHUD *hud = [kApplicationKeyWindow viewWithTag:911];
    if (![kApplicationKeyWindow viewWithTag:911]) {
        hud = [[WYVoiceRecordHUD alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
        hud.center = kApplicationKeyWindow.center;
        [kApplicationKeyWindow addSubview:hud];
    }

    [hud updatePeakPower:peakPower];
}

+ (void)showRecord {
    WYVoiceRecordHUD *hud = [kApplicationKeyWindow viewWithTag:911];
    if (![kApplicationKeyWindow viewWithTag:911]) {
        hud = [[WYVoiceRecordHUD alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
        hud.center = kApplicationKeyWindow.center;
        [kApplicationKeyWindow addSubview:hud];
        
        hud.alpha = 0;
        [UIView animateWithDuration:0.1 animations:^{
            hud.alpha = 1;
        }];
    }
    
    hud.statusButton.selected = NO;
    [hud.statusButton setTitle:@"手指上划，取消发送" forState:UIControlStateNormal];
}

+ (void)showCancel {
    WYVoiceRecordHUD *hud = [kApplicationKeyWindow viewWithTag:911];
    if (hud) {
        hud.recordTipImage.image = WYSessionBundleImageNamed(@"WYSession_return");
        hud.statusButton.selected = YES;
        [hud.statusButton setTitle:@"松开手指，取消发送" forState:UIControlStateNormal];
    }
}

+ (void)dismissWithRecordShort {
    WYVoiceRecordHUD *hud = [kApplicationKeyWindow viewWithTag:911];
    if (hud) {
        hud.recordTipImage.image = WYSessionBundleImageNamed(@"WYSession_return");
        hud.statusButton.selected = NO;
        [hud.statusButton setTitle:@"录音时间太短" forState:UIControlStateNormal];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                hud.alpha = 0;
            } completion:^(BOOL finished) {
                [hud removeFromSuperview];
            }];
        });
    }
   
}

+ (void)dismiss {
    WYVoiceRecordHUD *hud = [kApplicationKeyWindow viewWithTag:911];
    if (hud) {
        [UIView animateWithDuration:0.1 animations:^{
            hud.alpha = 0;
        } completion:^(BOOL finished) {
            [hud removeFromSuperview];
        }];
    }
}

#pragma mark - getter

- (UIImageView *)recordTipImage {
    if (_recordTipImage == nil) {
        _recordTipImage = [[UIImageView alloc] initWithImage:WYSessionBundleImageNamed(@"WYSession_voice_1")];
    }
    return _recordTipImage;
}

- (UIButton *)statusButton {
    if (_statusButton == nil) {
        _statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _statusButton.userInteractionEnabled = NO;
        _statusButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_statusButton setBackgroundImage:WYSessionBundleImageNamed(@"WYSession_red_background") forState:UIControlStateSelected];
    }
    return _statusButton;
}

- (NSDictionary *)animationDic {
    if (_animationDic == nil) {
        _animationDic = @{
                          @[@0,@0.125]:@"WYSession_voice_1",
                          @[@0.126,@0.250]:@"WYSession_voice_2",
                          @[@0.251,@0.375]:@"WYSession_voice_3",
                          @[@0.376,@0.500]:@"WYSession_voice_4",
                          @[@0.501,@0.625]:@"WYSession_voice_5",
                          @[@0.626,@0.750]:@"WYSession_voice_6",
                          @[@0.751,@0.875]:@"WYSession_voice_7",
                          @[@0.876,@1]:@"WYSession_voice_8"};
    }
    return _animationDic;
}

@end
