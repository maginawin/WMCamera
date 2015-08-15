//
//  ViewController.m
//  WMCamera
//
//  Created by wangwendong on 15/8/15.
//  Copyright (c) 2015年 wangwendong. All rights reserved.
//

#import "ViewController.h"
#import "WMCameraVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (IBAction)cameraClick:(id)sender {
    WMCameraVC *cameraVC = [[WMCameraVC alloc] initWithNibName:@"WMCameraVC" bundle:nil];
    cameraVC.modalPresentationStyle = UIModalPresentationPageSheet;
    cameraVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:cameraVC animated:YES completion:nil];
}

@end
