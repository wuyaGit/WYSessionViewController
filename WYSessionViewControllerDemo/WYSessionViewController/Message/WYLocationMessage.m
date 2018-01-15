//
//  WYLocationMessage.m
//  TrainSkill
//
//  Created by YANGGL on 2018/1/11.
//  Copyright © 2018年 Xwu. All rights reserved.
//

#import "WYLocationMessage.h"

@implementation WYLocationMessage

- (instancetype)initWithLocationImage:(UIImage *)image
                                 location:(CLLocationCoordinate2D)location
                             locationName:(NSString *)locationName {
    if (self = [super init]) {
        self.thumbnailImage = image;
        self.location = location;
        self.locationName = locationName;
    }
    
    return self;
}

+ (instancetype)messageWithLocationImage:(UIImage *)image
                                location:(CLLocationCoordinate2D)location
                            locationName:(NSString *)locationName {
    return [[self alloc] initWithLocationImage:image location:location locationName:locationName];
}

@end
