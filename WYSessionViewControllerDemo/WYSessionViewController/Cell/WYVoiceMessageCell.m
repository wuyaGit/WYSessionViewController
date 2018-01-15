//
//  WYVoiceMessageCell.m
//  TrainSkill
//
//  Created by YANGGL on 2018/1/11.
//  Copyright © 2018年 Xwu. All rights reserved.
//

#import "WYVoiceMessageCell.h"
#import "WYVoicePlayer.h"

@interface WYVoiceMessageCell ()

@property (nonatomic, strong) UIImageView *voiceAnimationImageView;
@property (nonatomic, strong) UILabel *voiceDurationLabel;

@property (nonatomic, assign) BOOL isPlaying;
@end

@implementation WYVoiceMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //
        [self.bubbleImageView addSubview:self.voiceAnimationImageView];
        [self.bubbleImageView addSubview:self.voiceDurationLabel];
        
        //
        [self.bubbleImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(CGSizeMake(80, 40)).priority(900);
        }];
        
        [self.voiceAnimationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            SMAS(make.left.equalTo(self.bubbleImageView.mas_left).offset(10));
            make.centerY.equalTo(self.bubbleImageView.mas_centerY).offset(0);
            make.size.mas_offset(CGSizeMake(20, 20));
        }];
        
        [self.voiceDurationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            SMAS(make.right.equalTo(self.bubbleImageView.mas_right).offset(5));
            make.centerY.equalTo(self.bubbleImageView.mas_centerY).offset(0);
        }];
        
        self.bubbleImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTouchPlayVoiceAction:)];
        [self.bubbleImageView addGestureRecognizer:tap];

    }
    return self;
}

- (void)updateDirection:(WYMessageDirection)direction {
    [super updateDirection:direction];
    
    [self.voiceAnimationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (direction == WYMessageDirection_RECEIVE) {
            SMAS(make.left.equalTo(self.bubbleImageView.mas_left).offset(10));
        }else{
            SMAS(make.right.equalTo(self.bubbleImageView.mas_right).offset(-10));
        }
    }];
    
    [self.voiceDurationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (direction == WYMessageDirection_RECEIVE) {
            SMAS(make.right.equalTo(self.bubbleImageView.mas_right).offset(-10));
        }else{
            SMAS(make.left.equalTo(self.bubbleImageView.mas_left).offset(10));
        }
    }];
    
    self.voiceDurationLabel.textColor = direction == WYMessageDirection_RECEIVE ? WYColorFromRGB(0xa2a2a2) : WYColorFromRGB(0x4182b5);

}

- (void)updateMessage:(WYMessage *)message showDate:(BOOL)showDate {
    [super updateMessage:message showDate:showDate];
    
    self.voiceAnimationImageView.animationImages = message.messageDirection == WYMessageDirection_RECEIVE ?
  @[WYSessionBundleImageNamed(@"WYSession_from_voice_1"), WYSessionBundleImageNamed(@"WYSession_from_voice_2"), WYSessionBundleImageNamed(@"WYSession_from_voice_3")] :
  @[WYSessionBundleImageNamed(@"WYSession_to_voice_1"), WYSessionBundleImageNamed(@"WYSession_to_voice_2"), WYSessionBundleImageNamed(@"WYSession_to_voice_3")];
    
    self.voiceAnimationImageView.image = message.messageDirection == WYMessageDirection_RECEIVE ? WYSessionBundleImageNamed(@"WYSession_from_voice") : WYSessionBundleImageNamed(@"WYSession_to_voice");
    
    self.voiceDurationLabel.text = [NSString stringWithFormat:@"%ld''",((WYVoiceMessage *)message.content).duration];
}

- (void)onTouchPlayVoiceAction:(id)sender {
    void (^completion)(void) = ^ {
        [self.voiceAnimationImageView stopAnimating];
        self.isPlaying = NO;
        
        [[WYVoicePlayer sharedInstance] cancelPlay];
    };
    
    if (!self.isPlaying) {
        [self.voiceAnimationImageView startAnimating];
        self.isPlaying = YES;
        
        [[WYVoicePlayer sharedInstance] playVoiceWithData:((WYVoiceMessage *)self.message.content).wavAudioData completion:completion];
    }else {
        completion();
    }
}

#pragma mark - getter

- (UIImageView *)voiceAnimationImageView {
    if (!_voiceAnimationImageView) {
        _voiceAnimationImageView = [[UIImageView alloc] init];
        _voiceAnimationImageView.userInteractionEnabled = YES;
        _voiceAnimationImageView.animationDuration = 1;
        _voiceAnimationImageView.animationRepeatCount = 0;
    }
    return _voiceAnimationImageView;
}

- (UILabel *)voiceDurationLabel {
    if (!_voiceDurationLabel) {
        _voiceDurationLabel = [[UILabel alloc] init];
        _voiceDurationLabel.textColor = WYColorFromRGB(0x4182b5);
        _voiceDurationLabel.font = [UIFont systemFontOfSize:15];
    }
    return _voiceDurationLabel;
}

@end
