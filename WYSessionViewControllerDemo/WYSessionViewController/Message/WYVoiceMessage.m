//
//  WYVoiceMessage.m
//  TrainSkill
//
//  Created by YANGGL on 2018/1/11.
//  Copyright © 2018年 Xwu. All rights reserved.
//

#import "WYVoiceMessage.h"

@implementation WYVoiceMessage

- (instancetype)initWithAudio:(NSData *)audioData duration:(long)duration {
    if (self = [super init]) {
        self.wavAudioData = audioData;
        self.duration = duration;
    }
    
    return self;
}

+ (instancetype)messageWithAudio:(NSData *)audioData duration:(long)duration {
    return [[self alloc] initWithAudio:audioData duration:duration];
}

@end
