//
//  WMCameraSet.h
//  WMCamera
//
//  Created by wangwendong on 15/8/15.
//  Copyright (c) 2015年 wangwendong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CameraFlashState)  {
    CameraFlashStateAuto = 0x01 << 0,
    CameraFlashStateON = 0x01 << 1,
    CameraFlashStateOFF = 0x01 << 2
};

@interface WMCameraSet : NSObject

+ (CameraFlashState)cameraFlashState;

+ (void)setCameraFlashState:(CameraFlashState)state;

@end
