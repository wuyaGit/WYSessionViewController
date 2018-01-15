//
//  WYUserInfo.h
//  TrainSkill
//
//  Created by YANGGL on 2018/1/11.
//  Copyright © 2018年 Xwu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYUserInfo : NSObject

@property(nonatomic, strong) NSString *userId;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *portraitUri;

- (instancetype)initWithUserId:(NSString *)userId
                          name:(NSString *)username
                      portrait:(NSString *)portrait;
@end
