//
//  WYEmojiBoardView.h
//  TrainSkill
//
//  Created by YANGGL on 2018/1/10.
//  Copyright © 2018年 Xwu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WYEmojiBoardViewDelegate;

@interface WYEmojiBoardView : UIView

@property (nonatomic, weak) id <WYEmojiBoardViewDelegate> delegate;
@end


@protocol WYEmojiBoardViewDelegate <NSObject>
@optional
- (void)emojiBoardViewDidSeletedEmoji:(NSString *)emoji;
- (void)emojiBoardViewDidBackspace;
- (void)emojiBoardViewDidSend;

@end
