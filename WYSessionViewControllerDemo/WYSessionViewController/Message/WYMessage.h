//
//  WYMessage.h
//  TrainSkill
//
//  Created by YANGGL on 2018/1/10.
//  Copyright © 2018年 Xwu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYMessageContent.h"
#import "WYTextMessage.h"
#import "WYImageMessage.h"
#import "WYVoiceMessage.h"
#import "WYLocationMessage.h"
#import "WYUserInfo.h"

typedef NS_ENUM(NSUInteger, WYConversationType) {
    WYConversationType_PRIVATE = 1,
    WYConversationType_GROUP = 2,
    WYConversationType_CHATROOM = 3,
};

typedef NS_ENUM(NSInteger, WYMessageDirection) {
    WYMessageDirection_SEND = 1,
    WYMessageDirection_RECEIVE = 2
};

typedef NS_ENUM(NSInteger, WYMessageSendStatus) {
    WYMessageSendStatus_SENDING = 10,
    WYMessageSendStatus_FAILED = 20,
    WYMessageSendStatus_SENT = 30,
};


@interface WYMessage : NSObject

@property(nonatomic, assign) WYConversationType conversationType;
@property(nonatomic, assign) WYMessageDirection messageDirection;
@property(nonatomic, assign) WYMessageSendStatus sentStatus;
@property(nonatomic, strong) NSString *targetId;            //会话id
@property(nonatomic, assign) long messageId;                //消息的ID（本地数据库索引唯一值）
@property(nonatomic, assign) long long receivedTime;        //接收时间（Unix时间戳、毫秒）
@property(nonatomic, assign) long long sentTime;            //发送时间（Unix时间戳、毫秒）

@property (nonatomic, strong) WYUserInfo *userInfo;
@property (nonatomic, strong) WYMessageContent *content;

- (instancetype)initWithType:(WYConversationType)conversationType
                    targetId:(NSString *)targetId
                   direction:(WYMessageDirection)messageDirection
                   messageId:(long)messageId
                     userInfo:(WYUserInfo *)userInfo
                     content:(WYMessageContent *)content;
+ (instancetype)messageWithType:(WYConversationType)conversationType
                       targetId:(NSString *)targetId
                      direction:(WYMessageDirection)messageDirection
                      messageId:(long)messageId
                       userInfo:(WYUserInfo *)userInfo
                        content:(WYMessageContent *)content;

@end
