//
//  WYVoiceRecorder.h
//  TrainSkill
//
//  Created by YANGGL on 2018/1/11.
//  Copyright © 2018年 Xwu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WYVoiceRecorderDelegate;

@interface WYVoiceRecorder : NSObject

@property (nonatomic, weak) id <WYVoiceRecorderDelegate> delegate;

+ (instancetype)sharedInstance; //没用到，因为有delegate

- (void)startRecord;
- (void)competionRecord;
- (void)cancelRecord;

@end

@protocol WYVoiceRecorderDelegate <NSObject>
@optional

- (void)recoredVoiceCompletionWithVoiceData:(NSData *)data duration:(long)duration;

@end
