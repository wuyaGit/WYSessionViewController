//
//  WYSessionMacro.h
//  TrainSkill
//
//  Created by YANGGL on 2018/1/10.
//  Copyright © 2018年 Xwu. All rights reserved.
//

#ifndef WYSessionMacro_h
#define WYSessionMacro_h

#import <Masonry.h>
#import "UITableView+FDTemplateLayoutCell.h"

/**
 *  Color
 */
#define WYColorWithRGBA(r, g, b, a) [UIColor colorWithRed:(r) / 255.0f green:(g) / 255.0f blue:(b) / 255.0f alpha:(a)]

#define WYColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define WYColorFromRGBA(rgbValue, a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

/**
 *  UIImage
 */
#define WYSessionBundleSourcePath(file) [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"WYSession.bundle"] stringByAppendingPathComponent:file]
#define WYSessionBundleImageNamed(file) [UIImage imageWithContentsOfFile:WYSessionBundleSourcePath(file)]

#endif /* WYSessionMacro_h */
