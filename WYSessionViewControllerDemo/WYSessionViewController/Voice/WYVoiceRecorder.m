//
//  WYVoiceRecorder.m
//  TrainSkill
//
//  Created by YANGGL on 2018/1/11.
//  Copyright © 2018年 Xwu. All rights reserved.
//

#import "WYVoiceRecorder.h"
#import <AVFoundation/AVFoundation.h>
#import "WYVoiceRecordHUD.h"

@interface WYVoiceRecorder ()<AVAudioRecorderDelegate>

@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation WYVoiceRecorder

#pragma mark - initializer

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

+ (instancetype)sharedInstance {
    static WYVoiceRecorder *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WYVoiceRecorder alloc] init];
    });
    return instance;
}

- (void)dealloc {
    if (self.audioRecorder) {
        [self.audioRecorder stop];
        self.audioRecorder.delegate = nil;
        self.audioRecorder = nil;
    }
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)configRecorder {
    if (self.audioRecorder) {
        [self.audioRecorder stop];
        [self.audioRecorder setDelegate:nil];
        self.audioRecorder = nil;
    }
    //audioSession
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];

    //audioRecorder
    NSURL *tmpUrl = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"tmp"]];

    NSDictionary *settings = @{
                               AVFormatIDKey                : @(kAudioFormatLinearPCM),
                               AVSampleRateKey              : @8000.f,
                               AVNumberOfChannelsKey        : @2,
                               AVLinearPCMBitDepthKey       : @16,
                               AVLinearPCMIsNonInterleaved  : @NO,
                               AVLinearPCMIsFloatKey        : @NO,
                               AVLinearPCMIsBigEndianKey    : @NO};
    
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:tmpUrl settings:settings error:nil];
    self.audioRecorder.meteringEnabled = YES;
    self.audioRecorder.delegate = self;
    if ([self.audioRecorder prepareToRecord]) {
        [self.audioRecorder record];
    }
}

- (void)configTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(listenVoiceVolume) userInfo:nil repeats:YES];
}

#pragma mark - private

- (void)listenVoiceVolume {
    [self.audioRecorder updateMeters];
    CGFloat lowPassResults = pow(10, (0.05 * [self.audioRecorder peakPowerForChannel:0]));
    [WYVoiceRecordHUD updatePeakPower:lowPassResults];
}

-(NSURL *)recordFilePath{
    return [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"tmp"]];
}

#pragma mark - public

- (void)startRecord {
    [self configRecorder];
    [self configTimer];
    
    [WYVoiceRecordHUD showRecord];
}

- (void)competionRecord {
    if (self.audioRecorder.currentTime > 2) {
        [WYVoiceRecordHUD dismiss];
        NSData *data = [[NSData alloc] initWithContentsOfURL:[self recordFilePath]];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(recoredVoiceCompletionWithVoiceData:duration:)]) {
            [self.delegate recoredVoiceCompletionWithVoiceData:data duration:self.audioRecorder.currentTime];
        }
    }else {
        [WYVoiceRecordHUD dismissWithRecordShort];
    }
    [self endRecord];
}

- (void)cancelRecord {
    [WYVoiceRecordHUD dismiss];
    [self endRecord];
}

- (void)endRecord {
    [self.audioRecorder stop];
    [self.audioRecorder deleteRecording];
    [self.timer invalidate];
}

@end
