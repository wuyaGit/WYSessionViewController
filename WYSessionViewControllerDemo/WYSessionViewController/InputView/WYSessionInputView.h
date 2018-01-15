//
//  WYSessionInputView.h
//  TrainSkill
//
//  Created by YANGGL on 2018/1/10.
//  Copyright © 2018年 Xwu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WYMessage;

@protocol WYSessionInputViewDelegate;

@interface WYSessionInputView : UIView

@property (nonatomic, weak) id <WYSessionInputViewDelegate> delegate;

- (void)hideAllKeyboard ;
@end

@protocol WYSessionInputViewDelegate <NSObject>
@optional

- (void)inputViewSendMessage:(WYMessage *)message;
- (void)inputViewHeightChanged:(CGFloat)offset;

@end
