//
//  WYLocationViewController.m
//  TrainSkill
//
//  Created by YANGGL on 2018/1/11.
//  Copyright © 2018年 Xwu. All rights reserved.
//

#import "WYLocationViewController.h"
#import <MapKit/MapKit.h>
#import "WYSessionMacro.h"
#import "WYLocationMessage.h"

@interface WYLocationViewController () <UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) MKUserLocation *userLocation;
@property (nonatomic, strong) MKPointAnnotation *annotation;

@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation WYLocationViewController

#pragma mark - Table view datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    CLPlacemark *item = self.dataSource[indexPath.row];
    
    cell.textLabel.text = item.name;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark – locationManager delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations {
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(locations[0].coordinate, 2000 ,2000);
    
    if (self.annotation == nil) {
        //没什么用，标识下第一次进来
        self.annotation = [[MKPointAnnotation alloc] init];
        MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:region];
        [self.mapView setRegion:adjustedRegion animated:YES];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {}

#pragma mark - mapView delegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count == 0 || error) {
            NSLog(@"找不到该位置");
            return;
        }
        // 当前地标
        CLPlacemark *pm = [placemarks firstObject];
        // 区域名称
        userLocation.title = pm.locality;
        // 详细名称
        userLocation.subtitle = pm.name;
        
        self.userLocation = userLocation;
        
        [self.dataSource removeAllObjects];
        [self.dataSource addObject:pm];
        [self.tableView reloadData];
    }];
}

#pragma mark - Cycle life

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
    UIBarButtonItem *sendItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(onTouchSendLocation:)];
    self.navigationItem.rightBarButtonItem = sendItem;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    //
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.tableView];
    
    [self.locationManager requestWhenInUseAuthorization];
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationManager startUpdatingLocation];
    }
    
    //
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.mas_offset(@300);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.mapView.mas_bottom).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onTouchSendLocation:(id)sender {
    if (self.userLocation == nil) {
        return;
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(locationViewSendMessage:)]) {
        UIImage *locationImage = [self snapshot:self.mapView];

        [self.delegate locationViewSendMessage:[WYLocationMessage messageWithLocationImage:locationImage
                                                                                  location:self.userLocation.location.coordinate
                                                                              locationName:self.userLocation.subtitle]];
    }
}

- (UIImage *)snapshot:(UIView *)view{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - getter

- (MKMapView *)mapView{
    if (!_mapView) {
        _mapView = [[MKMapView alloc] init];
        _mapView.mapType = MKMapTypeStandard;
        _mapView.showsUserLocation = YES;
        _mapView.delegate = self;
    }
    return _mapView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = WYColorFromRGB(0xebebeb);
        _tableView.backgroundColor = WYColorFromRGB(0xf8f8f8);
        _tableView.separatorColor = WYColorFromRGB(0xeeeeee);
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    }
    return _tableView;
}

- (CLLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.distanceFilter = kCLDistanceFilterNone;//距离筛选器，单位米（移动多少米才回调更新）
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest; //精确度
        _locationManager.delegate = self;
    }
    return _locationManager;
}

//- (MKPointAnnotation *)annotation {
//    if (!_annotation) {
//        _annotation = [[MKPointAnnotation alloc] init];
//    }
//    return _annotation;
//}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
