//
//  DeviceManagementHelper.h
//  IngenicoSDKTestApp
//
//  Copyright © 2016 RoamData. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RUA_MFI/RUA.h>

@protocol DeviceManagementDelegate <NSObject>

- (void)connectPairedDevice:(RUADevice*)device deviceType:(RUADeviceType)deviceType;

@end

@interface DeviceManagementHelper : NSObject

+ (id)sharedInstance;

- (void)initiateScan;

- (void)stopScan;

- (void)saveDevice:(RUADeviceType)deviceType deviceName:(RUADevice*)device;

@end
