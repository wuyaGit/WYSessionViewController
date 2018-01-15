//
//  WYImageMessage.h
//  TrainSkill
//
//  Created by YANGGL on 2018/1/11.
//  Copyright © 2018年 Xwu. All rights reserved.
//

#import "WYMessageContent.h"

@interface WYImageMessage : WYMessageContent

@property(nonatomic, strong) NSString *imageUrl;
@property(nonatomic, strong) UIImage *thumbnailImage;
@property(nonatomic, strong) UIImage *originalImage;
@property(nonatomic, strong) NSString *extra;

+ (instancetype)messageWithImage:(UIImage *)image;
@end
