//
//  AutoConnectionHelper.h
//  IngenicoSDKTestApp
//
//  Copyright © 2016 RoamData. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RUA_MFI/RUA.h>

@interface AutoConnectionHelper : NSObject

+ (id)sharedInstance;

- (void) initializeBluetoothManager;

- (void)initiateBLEDeviceScan;

- (void)accessoryDidConnect:(NSNotification*)note;

- (void)accessoryDidDisconnect:(NSNotification*)note;

- (void)retrievePairedDevices;

- (void)checkScannedPeripheralDeviceIsAlreadyPaired:(NSString*)deviceName isBLE:(BOOL)BLE deviceConnectedStatus:(BOOL)isConnected;

- (void)initiateMFIDeviceScan;

- (void)startScan;

- (void)stopScan;

@end
