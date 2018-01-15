//
//  WYVoiceMessage.h
//  TrainSkill
//
//  Created by YANGGL on 2018/1/11.
//  Copyright © 2018年 Xwu. All rights reserved.
//

#import "WYMessageContent.h"

@interface WYVoiceMessage : WYMessageContent

@property(nonatomic, strong) NSData *wavAudioData;
@property(nonatomic, assign) long duration;
@property(nonatomic, strong) NSString *extra;

+ (instancetype)messageWithAudio:(NSData *)audioData duration:(long)duration;
@end
