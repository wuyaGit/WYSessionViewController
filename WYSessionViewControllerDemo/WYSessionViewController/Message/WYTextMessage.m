//
//  WYTextMessage.m
//  TrainSkill
//
//  Created by YANGGL on 2018/1/11.
//  Copyright © 2018年 Xwu. All rights reserved.
//

#import "WYTextMessage.h"

@implementation WYTextMessage

- (instancetype)initWithContent:(NSString *)content {
    if (self = [super init]) {
        self.content = content;
    }
    
    return self;
}

+ (instancetype)messageWithContent:(NSString *)content {
    return [[self alloc] initWithContent:content];
}

@end
