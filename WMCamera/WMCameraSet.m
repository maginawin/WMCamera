//
//  WMCameraSet.m
//  WMCamera
//
//  Created by wangwendong on 15/8/15.
//  Copyright (c) 2015年 wangwendong. All rights reserved.
//

#import "WMCameraSet.h"

NSString *const kCameraFlashState = @"com.maginawin.kCameraFlashState";

@implementation WMCameraSet

+ (CameraFlashState)cameraFlashState {
    CameraFlashState state = [[NSUserDefaults standardUserDefaults] integerForKey:kCameraFlashState];
    
    if (!state) {
        state = CameraFlashStateAuto;
    }
    
    return state;
}

+ (void)setCameraFlashState:(CameraFlashState)state {
    if (state > CameraFlashStateOFF) {
        state = CameraFlashStateAuto;
    }
    
    [[NSUserDefaults standardUserDefaults] setInteger:state forKey:kCameraFlashState];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
