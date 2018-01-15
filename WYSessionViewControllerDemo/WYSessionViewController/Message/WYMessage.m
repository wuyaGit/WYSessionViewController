//
//  WYMessage.m
//  TrainSkill
//
//  Created by YANGGL on 2018/1/10.
//  Copyright © 2018年 Xwu. All rights reserved.
//

#import "WYMessage.h"

@implementation WYMessage

- (instancetype)initWithType:(WYConversationType)conversationType
                    targetId:(NSString *)targetId
                   direction:(WYMessageDirection)messageDirection
                   messageId:(long)messageId
                    userInfo:(WYUserInfo *)userInfo
                     content:(WYMessageContent *)content {
    if (self = [super init]) {
        self.conversationType = conversationType;
        self.targetId = targetId;
        self.messageDirection = messageDirection;
        self.messageId = messageId;
        self.userInfo = userInfo;
        self.content = content;
    }
    return self;
}

+ (instancetype)messageWithType:(WYConversationType)conversationType
                       targetId:(NSString *)targetId
                      direction:(WYMessageDirection)messageDirection
                      messageId:(long)messageId
                       userInfo:(WYUserInfo *)userInfo
                        content:(WYMessageContent *)content  {
    return [[self alloc] initWithType:conversationType targetId:targetId direction:messageDirection messageId:messageId userInfo:userInfo content:content];
}

@end
