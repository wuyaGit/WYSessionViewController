//
//  WYImageMessageCell.m
//  TrainSkill
//
//  Created by YANGGL on 2018/1/11.
//  Copyright © 2018年 Xwu. All rights reserved.
//

#import "WYImageMessageCell.h"

@interface WYImageMessageCell ()

@property (nonatomic, strong) UIImageView *photoImageView;
@end

@implementation WYImageMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //
        [self.bubbleImageView addSubview:self.photoImageView];
        
        //
        [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.bubbleImageView);
        }];
        [self.photoImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(CGSizeMake(150, 150)).priority(900);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTouchClickAction:)];
        [self.photoImageView addGestureRecognizer:tap];
    }
    return self;
}

- (void)updateMessage:(WYMessage *)message showDate:(BOOL)showDate {
    [super updateMessage:message showDate:showDate];
    
    WYImageMessage *imgMessage = (WYImageMessage *)message.content;
    self.photoImageView.image = imgMessage.thumbnailImage;
    
    CGSize size = CGSizeMake(150, 150);
    
    UIImageView *imageViewMask = [[UIImageView alloc] initWithImage:self.bubbleImageView.image];
    imageViewMask.frame = CGRectMake(0, 0, size.width, size.height);
    self.photoImageView.layer.mask = imageViewMask.layer;
    
    
}

- (void)onTouchClickAction:(id)sender {
    WYImageMessage *imgMessage = (WYImageMessage *)self.message.content;
    if (imgMessage.originalImage) {
        
    }else {
        
    }
}

#pragma mark - getter

- (UIImageView *)photoImageView{
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc] init];
        _photoImageView.layer.masksToBounds = YES;
        _photoImageView.userInteractionEnabled = YES;
        _photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_photoImageView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _photoImageView;
}


@end
