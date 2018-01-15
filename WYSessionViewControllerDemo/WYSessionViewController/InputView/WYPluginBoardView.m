//
//  WYPluginBoardView.m
//  TrainSkill
//
//  Created by YANGGL on 2018/1/10.
//  Copyright © 2018年 Xwu. All rights reserved.
//

#import "WYPluginBoardView.h"
#import "WYSessionMacro.h"


@implementation WYPluginBoardView {
    BOOL hasLayout;
}

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = WYColorFromRGB(0xFAFAFA);
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (hasLayout) {
        return;
    }
    hasLayout = YES;
    CGFloat spacingWidth = (self.frame.size.width - 70 * 4) / 5;
    CGFloat spacingHeight = (self.frame.size.height - 70 * 2) / 3;

    NSArray *array = [self.dataSource pluginBoardItems];
    for (NSInteger i = 0; i < array.count; i++) {
        WYPluginBoardItem *item = array[i];
        
        NSInteger idxW = i % 4;
        NSInteger idxH = (i / 4) % 2;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(spacingWidth * (idxW + 1) + idxW * 70 , spacingHeight * (idxH + 1) + idxH * 70, 70, 70)];
        [button setImage:WYSessionBundleImageNamed(item.imageName) forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setTag:100 + i];
        [button addTarget:self action:@selector(onTouchClickItem:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
    }
}

- (void)onTouchClickItem:(id)sender {
    UIButton *button = sender;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pluginBoardDidClickItem:)] ) {
        [self.delegate pluginBoardDidClickItem:button.tag - 100];
    }
}

@end


@implementation WYPluginBoardItem

- (instancetype)initWithImageNamed:(NSString *)imageName {
    if (self = [super init]) {
        self.imageName = imageName;
    }
    return self;
}

@end


