//
//  WYPluginBoardView.h
//  TrainSkill
//
//  Created by YANGGL on 2018/1/10.
//  Copyright © 2018年 Xwu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WYPluginBoardViewDelegate, WYPluginBoardViewDataSource;

@interface WYPluginBoardView : UIView

@property (nonatomic, weak) id<WYPluginBoardViewDelegate> delegate;
@property (nonatomic, weak) id<WYPluginBoardViewDataSource> dataSource;
@end

@interface WYPluginBoardItem: NSObject

@property (nonatomic, copy) NSString *imageName;

- (instancetype)initWithImageNamed:(NSString *)imageName;
@end

@protocol WYPluginBoardViewDelegate <NSObject>
@optional
- (void)pluginBoardDidClickItem:(NSInteger)index;

@end

@protocol WYPluginBoardViewDataSource <NSObject>
@required
- (NSArray *)pluginBoardItems;

@end
