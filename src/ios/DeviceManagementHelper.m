//
//  DeviceManagementHelper.h
//  IngenicoSDKTestApp
//
//  Copyright © 2016 RoamData. All rights reserved.
//

#import "DeviceManagementHelper.h"
#import <ExternalAccessory/ExternalAccessory.h>
#import <CoreBluetooth/CoreBluetooth.h>

NSString *const deviceObjkey = @"PairedDevices";
NSString *const deviceTypeKey = @"PairedDevicesType";

@interface DeviceManagementHelper() <CBCentralManagerDelegate>
{
    CBCentralManager *blueToothManager;
    EAAccessoryManager *accessoryManager;
    NSMutableArray *pairedDevices;
    NSMutableDictionary *pairedDeviceTypes;
    id<DeviceManagementDelegate> _delegate;
    BOOL isScanInitiated;
}

@end

@implementation DeviceManagementHelper

+ (id)sharedInstance {
    static DeviceManagementHelper *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[DeviceManagementHelper alloc] init];
    });
    return _instance;
}

- (id)init {
    if (self = [super init]) {
        pairedDevices = [NSMutableArray new];
        pairedDeviceTypes = [NSMutableDictionary new];
        accessoryManager = [EAAccessoryManager sharedAccessoryManager];
    }
    return self;
}

- (void)setDelegate:(id<DeviceManagementDelegate>)delegate{
    _delegate = delegate;
}

- (void)retrievePairedDevices
{
    NSMutableArray *archiveArray = [[NSUserDefaults standardUserDefaults] objectForKey:deviceObjkey];
    NSDictionary *deviceType = [[NSUserDefaults standardUserDefaults] objectForKey:deviceTypeKey];
    [pairedDevices removeAllObjects];
    [pairedDeviceTypes removeAllObjects];
    [pairedDeviceTypes addEntriesFromDictionary:deviceType];
    for (NSData* data in archiveArray) {
        RUADevice* device =[NSKeyedUnarchiver unarchiveObjectWithData:data] ;
        [pairedDevices addObject:device];
    }
}

- (void)initiateScan
{    
    isScanInitiated = YES;
    blueToothManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
    
    [accessoryManager registerForLocalNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(accessoryDidConnect:)
                                                 name:EAAccessoryDidConnectNotification
                                               object:nil];
    //Scan for MFI devices (RP450)    
    for(EAAccessory *accessory in accessoryManager.connectedAccessories)
    {
        NSLog(@"INIT SCAN 2");
        if([accessory.name length]>0)
        {
            [self checkScannedPeripheralDeviceIsAlreadyPaired:accessory.name isBLE:NO  deviceConnectedStatus:YES];
        }
    }
}

- (void)stopScan{
    isScanInitiated = NO;
    [blueToothManager stopScan];
    [accessoryManager unregisterForLocalNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:EAAccessoryDidConnectNotification];
}

- (NSNumber *)getPairedDeviceType:(RUADeviceType)deviceType{
    switch (deviceType) {
        case RUADeviceTypeRP450c:
            return [NSNumber numberWithInteger:RUADeviceTypeRP450c];
        case RUADeviceTypeRP45BT:
            return [NSNumber numberWithInteger:RUADeviceTypeRP45BT];
        case RUADeviceTypeRP750x:
            return [NSNumber numberWithInteger:RUADeviceTypeRP750x];
        case RUADeviceTypeMOBY3000:
            return [NSNumber numberWithInteger:RUADeviceTypeMOBY3000];
        case RUADeviceTypeMOBY8500:
            return [NSNumber numberWithInteger:RUADeviceTypeMOBY8500];
        default:
            return nil;
    }
}

- (void)saveDevice:(RUADeviceType)deviceType deviceName:(RUADevice*)device
{
    [self retrievePairedDevices];
    NSMutableArray *archiveArray = [NSMutableArray new];
    [archiveArray addObjectsFromArray: [[NSUserDefaults standardUserDefaults] objectForKey:deviceObjkey]];
    
    if(archiveArray == nil)
    {
        archiveArray = [NSMutableArray new];
    }
    NSData *addEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:device];
    if(![archiveArray containsObject:addEncodedObject]){
        [archiveArray addObject:addEncodedObject];
        [[NSUserDefaults standardUserDefaults] setObject:archiveArray forKey:deviceObjkey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [pairedDeviceTypes setObject:[self getPairedDeviceType:deviceType] forKey:device.name];
        [[NSUserDefaults standardUserDefaults] setObject:pairedDeviceTypes forKey:deviceTypeKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self retrievePairedDevices];
    }
}

- (void)checkScannedPeripheralDeviceIsAlreadyPaired:(NSString*)deviceName isBLE:(BOOL)BLE deviceConnectedStatus:(BOOL)isConnected
{
    [self retrievePairedDevices];
    for(RUADevice *device in pairedDevices)
    {
        if([[device.name lowercaseString] isEqualToString:[deviceName lowercaseString]])
        {
            RUADeviceType selectedDeviceType;
            
            if([pairedDeviceTypes objectForKey:device.name] && [[pairedDeviceTypes objectForKey:device.name] intValue] ==  RUADeviceTypeRP450c)
            {
                selectedDeviceType = RUADeviceTypeRP450c;
            }
            else if([pairedDeviceTypes objectForKey:device.name] && [[pairedDeviceTypes objectForKey:device.name] intValue] ==  RUADeviceTypeRP750x)
            {
                selectedDeviceType = RUADeviceTypeRP750x;
            }
            else if([pairedDeviceTypes objectForKey:device.name] && [[pairedDeviceTypes objectForKey:device.name] intValue] ==  RUADeviceTypeRP45BT)
            {
                selectedDeviceType = RUADeviceTypeRP45BT;
            }
            else if([pairedDeviceTypes objectForKey:device.name] && [[pairedDeviceTypes objectForKey:device.name] intValue] ==  RUADeviceTypeMOBY3000)
            {
                selectedDeviceType = RUADeviceTypeMOBY3000;
            }
            else if([pairedDeviceTypes objectForKey:device.name] && [[pairedDeviceTypes objectForKey:device.name] intValue] ==  RUADeviceTypeMOBY8500)
            {
                selectedDeviceType = RUADeviceTypeMOBY8500;
            }
            else{
                selectedDeviceType = RUADeviceTypeUnknown;
            }
            
            if((selectedDeviceType == RUADeviceTypeRP450c && !BLE) || (selectedDeviceType == RUADeviceTypeRP750x && BLE) ||
               (selectedDeviceType == RUADeviceTypeRP45BT && BLE) || (selectedDeviceType == RUADeviceTypeMOBY3000 && BLE) ||
               (selectedDeviceType == RUADeviceTypeMOBY8500 && BLE))
            {
                [_delegate connectPairedDevice:device deviceType:selectedDeviceType];
            }
            break;
        }
    }
}

#pragma mark - CBCentralManagerDelegate delegate Methods


- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if(blueToothManager.state == CBCentralManagerStatePoweredOn)
    {
        //Scan for BLE devices (RP750/MOBY3000)s
        [blueToothManager scanForPeripheralsWithServices:nil options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @NO }];
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    if([peripheral.name length]>0)
    {
        // Connect only BLE devices using this delegate method. Activating MFI devices may fail when MFI devices are not connected in system's bluetooth settings. Use EAAccessoryDidConnectNotification method to connect MFI devices.
        [self checkScannedPeripheralDeviceIsAlreadyPaired:peripheral.name isBLE:YES deviceConnectedStatus:peripheral.state == CBPeripheralStateConnected ? YES : NO];
    }
}

#pragma mark - EAAccessoryDidConnectNotification

- (void)accessoryDidConnect:(NSNotification*)note
{
    EAAccessory* accessory = [note.userInfo objectForKey:EAAccessoryKey];
    
    if([accessory.name length]>0)
    {
        [self checkScannedPeripheralDeviceIsAlreadyPaired:accessory.name isBLE:NO deviceConnectedStatus:YES];
    }
}

@end
