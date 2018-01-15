//
//  WYVoicePlayer.h
//  TrainSkill
//
//  Created by YANGGL on 2018/1/11.
//  Copyright © 2018年 Xwu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYVoicePlayer : NSObject

+ (instancetype)sharedInstance;

- (void)playVoiceWithData:(NSData *)data completion:(void (^)(void))completion;
- (void)cancelPlay;
@end
