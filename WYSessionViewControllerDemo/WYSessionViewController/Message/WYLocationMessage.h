//
//  WYLocationMessage.h
//  TrainSkill
//
//  Created by YANGGL on 2018/1/11.
//  Copyright © 2018年 Xwu. All rights reserved.
//

#import "WYMessageContent.h"
#import <CoreLocation/CoreLocation.h>

@interface WYLocationMessage : WYMessageContent

@property(nonatomic, assign) CLLocationCoordinate2D location;
@property(nonatomic, strong) NSString *locationName;
@property(nonatomic, strong) UIImage *thumbnailImage;
@property(nonatomic, strong) NSString *extra;

+ (instancetype)messageWithLocationImage:(UIImage *)image
                                location:(CLLocationCoordinate2D)location
                            locationName:(NSString *)locationName;

@end
