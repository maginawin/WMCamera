//
//  WMCameraVC.m
//  WMCamera
//
//  Created by wangwendong on 15/8/15.
//  Copyright (c) 2015年 wangwendong. All rights reserved.
//

#import "WMCameraVC.h"
#import "WMCameraSet.h"
#import "WMRecordManager.h"
#import <AVFoundation/AVFoundation.h>

@interface WMCameraVC () <WMRecordManagerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *flashStateButton;

@property (strong, nonatomic) WMRecordManager *recordManager;

@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation WMCameraVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    [self configureBase];
    [self configureNoti];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self configureBase];
}

- (IBAction)flashStateClick:(id)sender {
    CameraFlashState newState = [WMCameraSet cameraFlashState] << 1;
    [WMCameraSet setCameraFlashState:newState];
    
    [self reloadCameraFlashState];
}

- (IBAction)closeClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)toggleCameraClick:(id)sender {
    [_recordManager toggleCamera];
    
    [self autoFocus];
}


- (IBAction)takePhotographClick:(id)sender {
    [self takePhoto];
}

#pragma mark - Assistor

- (void)takePhoto {
    [_recordManager captureStillImage];
    
    UIView *flashView = [[UIView alloc] initWithFrame:self.view.bounds];
    flashView.backgroundColor = [UIColor whiteColor];
    [self.view.window addSubview:flashView];
    
    [UIView animateWithDuration:0.3f animations:^ {
        [flashView setAlpha:0];
    } completion:^ (BOOL finished) {
        [flashView removeFromSuperview];
    }];
}

- (void)reloadCameraFlashState {
    CameraFlashState state = [WMCameraSet cameraFlashState];
    
    NSString *stateText = [NSString string];
    AVCaptureFlashMode flashMode;
//    AVCaptureTorchMode torchMode;
    
    switch (state) {
        case CameraFlashStateAuto: {
            stateText = @"AUTO";
            flashMode = AVCaptureFlashModeAuto;
//            torchMode = AVCaptureTorchModeAuto;
            break;
        }
        case CameraFlashStateON: {
            stateText = @"ON";
            flashMode = AVCaptureFlashModeOn;
//            torchMode = AVCaptureTorchModeOn;
            break;
        }
        case CameraFlashStateOFF: {
            stateText = @"OFF";
            flashMode = AVCaptureFlashModeOff;
//            torchMode = AVCaptureTorchModeOff;
            break;
        }
    }
    
    // 赋值时不闪动, 则以下两值均要赋予
    _flashStateButton.titleLabel.text = stateText;
    [_flashStateButton setTitle:stateText forState:UIControlStateNormal];
    
    [_recordManager updateCaptureFlashMode:flashMode captureTorchMode:AVCaptureTorchModeAuto];
}

- (void)autoFocus {
    if ([_recordManager.videoInput.device isFocusPointOfInterestSupported]) {
        [_recordManager continuousFocusAtPoint:CGPointMake(0.5f, 0.5f)];
    }
}

#pragma mark - Configure

- (void)configureBase {
    // 隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [self reloadCameraFlashState];
    
    //
    self.view.backgroundColor = [UIColor blackColor];
    
    [self configureCamera];
}

- (void)configureCamera {
    if (!_recordManager) {
        _recordManager = [[WMRecordManager alloc] init];
        _recordManager.delegate = self;
        if ([_recordManager setupSession]) {
            _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_recordManager.session];
            _previewLayer.frame = self.view.bounds;
            [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
            [self.view.layer insertSublayer:_previewLayer atIndex:0];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
                [_recordManager.session startRunning];
                
                dispatch_async(dispatch_get_main_queue(), ^ {
                    [self reloadCameraFlashState];
                });
            });
            
            [self autoFocus];
        }
    }
}

- (void)configureNoti {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackgroundNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
}

#pragma mark - Selector

- (void)applicationDidEnterBackgroundNotification {

}

- (void)applicationWillEnterForegroundNotification {
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self configureCamera];
    });
}

@end
