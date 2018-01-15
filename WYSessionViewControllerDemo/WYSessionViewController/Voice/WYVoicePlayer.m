//
//  WYVoicePlayer.m
//  TrainSkill
//
//  Created by YANGGL on 2018/1/11.
//  Copyright © 2018年 Xwu. All rights reserved.
//

#import "WYVoicePlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface WYVoicePlayer () <AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, copy) void (^completion) (void);

@end

@implementation WYVoicePlayer

#pragma mark - initializer

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

+ (instancetype)sharedInstance {
    static WYVoicePlayer *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WYVoicePlayer alloc] init];
    });
    return instance;
}

#pragma mark - public

- (void)playVoiceWithData:(NSData *)data completion:(void (^)(void))completion {
    if (self.audioPlayer) {
        [self.audioPlayer stop];
        [self.audioPlayer setDelegate:nil];
        self.audioPlayer = nil;
    }
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];

    self.completion = completion;
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
    self.audioPlayer.delegate = self;
    if ([self.audioPlayer prepareToPlay]) {
        [self.audioPlayer play];
    }
}

- (void)cancelPlay {
    if (self.audioPlayer && self.audioPlayer.isPlaying) {
        [self.audioPlayer stop];        
    }
}

#pragma mark - audioPlayer delegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (self.completion) {
        self.completion();
    }
}

@end
