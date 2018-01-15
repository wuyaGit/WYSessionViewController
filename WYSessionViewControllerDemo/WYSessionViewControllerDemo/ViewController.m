//
//  ViewController.m
//  WYSessionViewControllerDemo
//
//  Created by YANGGL on 2018/1/15.
//  Copyright © 2018年 YANGGL. All rights reserved.
//

#import "ViewController.h"

#import "WYSessionViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushSessionViewController:(id)sender {
    WYSessionViewController *sessionViewController = [[WYSessionViewController alloc] init];
    [self.navigationController pushViewController:sessionViewController animated:YES];
}

@end
