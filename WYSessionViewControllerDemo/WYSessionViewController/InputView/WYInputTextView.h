//
//  WYInputTextView.h
//  TrainSkill
//
//  Created by YANGGL on 2018/1/10.
//  Copyright © 2018年 Xwu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYInputTextView : UITextView

@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic, copy) NSString *placeholderText;
@property (nonatomic, assign) CGFloat maxTextViewHeight;
@end
