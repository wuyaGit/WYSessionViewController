//
//  WYLocationMessageCell.m
//  TrainSkill
//
//  Created by YANGGL on 2018/1/11.
//  Copyright © 2018年 Xwu. All rights reserved.
//

#import "WYLocationMessageCell.h"
#import <MapKit/MapKit.h>
#import "WYMessage.h"
#import "WYSessionMacro.h"

@interface WYLocationMessageCell()

@property(nonatomic,strong)UIImageView *previewImageView;
@property(nonatomic,strong)UILabel *placeLabel;

@end

@implementation WYLocationMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //
        [self.bubbleImageView addSubview:self.previewImageView];
        [self.previewImageView addSubview:self.placeLabel];

        //
        [self.previewImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.bubbleImageView).priority(1);
        }];
        
        [self.previewImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(CGSizeMake(187.5, 150));
        }];
        
        [self.placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.previewImageView.mas_left).offset(0);
            make.right.equalTo(self.previewImageView.mas_right).offset(0);
            make.bottom.equalTo(self.previewImageView.mas_bottom).offset(0);
            make.height.mas_offset(30);
        }];
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTouchClickAction:)];
        [self.previewImageView addGestureRecognizer:tap];
    }
    return self;
}


- (void)updateMessage:(WYMessage *)message showDate:(BOOL)showDate{
    [super updateMessage:message showDate:showDate];
    WYLocationMessage *locMessage = (WYLocationMessage *)message.content;
    self.previewImageView.image = locMessage.thumbnailImage;
    self.placeLabel.text = locMessage.locationName;
    
    CGSize size = CGSizeMake(187.5, 150);
    
    UIImageView *imageViewMask = [[UIImageView alloc] initWithImage:self.bubbleImageView.image];
    imageViewMask.frame = CGRectMake(0, 0, size.width, size.height);
    self.previewImageView.layer.mask = imageViewMask.layer;
}

- (void)onTouchClickAction:(id)sender {
    WYLocationMessage *locMessage = (WYLocationMessage *)self.message.content;
    
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:locMessage.location addressDictionary:nil]];
    toLocation.name = locMessage.locationName;
    NSDictionary *launchOptions = [NSDictionary
                                   dictionaryWithObjects:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeDriving, [NSNumber numberWithBool:YES], nil]
                                   forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsShowsTrafficKey, nil]];
    [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation, toLocation, nil]
                   launchOptions:launchOptions];
}

#pragma mark - getter

- (UIImageView *)previewImageView{
    if (!_previewImageView) {
        _previewImageView = [[UIImageView alloc] init];
        _previewImageView.layer.masksToBounds = YES;
        _previewImageView.userInteractionEnabled = YES;
        _previewImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _previewImageView;
}

- (UILabel *)placeLabel{
    if (!_placeLabel) {
        _placeLabel = [[UILabel alloc] init];
        _placeLabel.font = [UIFont systemFontOfSize:14];
        _placeLabel.textColor = WYColorFromRGB(0xffffff);
        _placeLabel.backgroundColor = WYColorFromRGBA(0x000000, 0.7);
        _placeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _placeLabel;
}

@end
