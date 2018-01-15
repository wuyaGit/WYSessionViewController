//
//  WYTextMessage.h
//  TrainSkill
//
//  Created by YANGGL on 2018/1/11.
//  Copyright © 2018年 Xwu. All rights reserved.
//

#import "WYMessageContent.h"

@interface WYTextMessage : WYMessageContent

@property(nonatomic, strong) NSString *content;
@property(nonatomic, strong) NSString *extra;

+ (instancetype)messageWithContent:(NSString *)content;

@end
