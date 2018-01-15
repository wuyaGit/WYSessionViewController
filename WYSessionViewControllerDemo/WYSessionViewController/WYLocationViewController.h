//
//  WYLocationViewController.h
//  TrainSkill
//
//  Created by YANGGL on 2018/1/11.
//  Copyright © 2018年 Xwu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WYLocationMessage;
@protocol WYLocationViewControllerDelegate;

@interface WYLocationViewController : UIViewController

@property (nonatomic, weak) id<WYLocationViewControllerDelegate> delegate;
@end

@protocol WYLocationViewControllerDelegate <NSObject>

- (void)locationViewSendMessage:(WYLocationMessage *)content;
@end
