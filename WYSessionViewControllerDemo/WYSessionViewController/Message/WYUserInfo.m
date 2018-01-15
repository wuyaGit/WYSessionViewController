//
//  WYUserInfo.m
//  TrainSkill
//
//  Created by YANGGL on 2018/1/11.
//  Copyright © 2018年 Xwu. All rights reserved.
//

#import "WYUserInfo.h"

@implementation WYUserInfo

- (instancetype)initWithUserId:(NSString *)userId name:(NSString *)username portrait:(NSString *)portrait {
    if (self = [super init]) {
        self.userId = userId;
        self.name = username;
        self.portraitUri = portrait;
    }
    return self;
}

@end
