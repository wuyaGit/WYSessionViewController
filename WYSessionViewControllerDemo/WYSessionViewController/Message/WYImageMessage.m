//
//  WYImageMessage.m
//  TrainSkill
//
//  Created by YANGGL on 2018/1/11.
//  Copyright © 2018年 Xwu. All rights reserved.
//

#import "WYImageMessage.h"

@implementation WYImageMessage

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super init]) {
        self.thumbnailImage = image;
//        self.location = location;
//        self.locationName = locationName;
    }
    
    return self;
}

+ (instancetype)messageWithImage:(UIImage *)image {
    return [[self alloc] initWithImage:image];
}

@end
