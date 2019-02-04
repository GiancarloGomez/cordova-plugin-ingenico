#import "AutoConnectionHelper.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <ExternalAccessory/ExternalAccessory.h>

NSString *const deviceObjkey = @"PairedDevices";
NSString *const deviceTypeKey = @"PairedDevicesType";

@interface AutoConnectionHelper() <CBCentralManagerDelegate>
{
	CBCentralManager *blueToothManager;
	EAAccessoryManager *accessoryManager;
	NSMutableArray *pairedDevices;
	NSMutableDictionary *pairedDeviceTypes;
}
@end

@implementation AutoConnectionHelper

+ (id)sharedInstance {
	static AutoConnectionHelper *_instance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_instance = [[AutoConnectionHelper alloc] init];
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

#pragma mark - BLE / Bluetooth Classic card readers (RP45BT, RP750, MOBY/3000, MOBY/8500)
// Step 1: Initialize Bluetooth Manager.
- (void) initializeBluetoothManager {
	if(blueToothManager == nil)
	{
		//blueToothManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:options];
        blueToothManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
	}
}

// Step 2: Implement CBManagerDelegate.
- (void) centralManagerDidUpdateState:(CBCentralManager *) central {
	//start scan
}

- (void) centralManager:(CBCentralManager *) central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
	if([peripheral.name length]>0)
	{
		// Connect only BLE devices using this delegate method. Activating MFI devices may fail when MFI devices are not connected in system's bluetooth settings.
		// Use EAAccessoryDidConnectNotification method to connect MFI devices.
		[self checkScannedPeripheralDeviceIsAlreadyPaired:peripheral.name
		isBLE:YES deviceConnectedStatus:peripheral.state == CBPeripheralStateConnected ? YES : NO];
	}
}

//Step 3: Scan for BLE devices using bluetoothManager
- (void) initiateBLEDeviceScan
{
	if(blueToothManager.state == CBCentralManagerStatePoweredOn)
	{
		//Scan for BLE devices (RP750/MOBY3000)
		[blueToothManager scanForPeripheralsWithServices:nil options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @NO }];
	}
}

#pragma mark - MFI Card reader (RP450 AJ)
//Step 1: Add selectors for EAAccessory notifications.
- (void)accessoryDidConnect:(NSNotification*)note
{
	EAAccessory* accessory = [note.userInfo objectForKey:EAAccessoryKey];
	if([accessory.name length]>0)
	{
		[self checkScannedPeripheralDeviceIsAlreadyPaired:accessory.name
		isBLE:NO deviceConnectedStatus:YES];
	}
}

- (void)accessoryDidDisconnect:(NSNotification*)note
{
	//MFI device disconnected.
	//Display alert and restart scan.
}

//Step 2: Subscribe to EAAccessory notifications.
//Step 3: Scan for MFI devices using EAAccessory.
- (void)initiateMFIDeviceScan
{
	//Subscribe to EAAccessory Notifications
	[accessoryManager registerForLocalNotifications];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accessoryDidConnect:)
		name:EAAccessoryDidConnectNotification object:nil];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accessoryDidDisconnect:)
		name:EAAccessoryDidDisconnectNotification object:nil];

	//Scan for MFI devices (RP450)
	for(EAAccessory *accessory in accessoryManager.connectedAccessories)
	{
		if([accessory.name length]>0)
		{
			[self checkScannedPeripheralDeviceIsAlreadyPaired:accessory.name isBLE:NO deviceConnectedStatus:YES];
		}
	}
}

#pragma mark - Connecting to a paired reader
//Step 1: Retrieve paired devices
- (void)retrievePairedDevices
{
	//retrieve paired devices and device types from NSUserDefaults
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

//Step 2: Check if scanned device is already paired.
//Step 3: If paired, make sure BLE readers were discovered through CB and MFI through EA Accessory and connect to the device.
- (void)checkScannedPeripheralDeviceIsAlreadyPaired:(NSString*)deviceName isBLE:(BOOL)BLE deviceConnectedStatus:(BOOL)isConnected
{
	[self retrievePairedDevices];
	for(RUADevice *device in pairedDevices)
	{
		if([[device.name lowercaseString] isEqualToString:[deviceName lowercaseString]])
		{
			RUADeviceType selectedDeviceType;
			if([pairedDeviceTypes objectForKey:device.name] && [[pairedDeviceTypes objectForKey:device.name] intValue] == RUADeviceTypeRP450c)
			{
				selectedDeviceType = RUADeviceTypeRP450c;
			} else if([pairedDeviceTypes objectForKey:device.name] && [[pairedDeviceTypes objectForKey:device.name] intValue] == RUADeviceTypeRP750x)
			{
				selectedDeviceType = RUADeviceTypeRP750x;
			} else if([pairedDeviceTypes objectForKey:device.name] && [[pairedDeviceTypes objectForKey:device.name] intValue] == RUADeviceTypeRP45BT)
			{
				selectedDeviceType = RUADeviceTypeRP45BT;
			} else if([pairedDeviceTypes objectForKey:device.name] && [[pairedDeviceTypes objectForKey:device.name] intValue] == RUADeviceTypeMOBY3000)
			{
				selectedDeviceType = RUADeviceTypeMOBY3000;
			} else if([pairedDeviceTypes objectForKey:device.name] && [[pairedDeviceTypes objectForKey:device.name] intValue] == RUADeviceTypeMOBY8500)
			{
				selectedDeviceType = RUADeviceTypeMOBY8500;
			} else{
				selectedDeviceType = RUADeviceTypeUnknown;
			}
			
			if(	(selectedDeviceType == RUADeviceTypeRP450c && !BLE) ||
				(selectedDeviceType == RUADeviceTypeRP750x && BLE) ||
				(selectedDeviceType == RUADeviceTypeRP45BT && BLE) ||
				(selectedDeviceType == RUADeviceTypeMOBY3000 && BLE) ||
				(selectedDeviceType == RUADeviceTypeMOBY8500 && BLE)) 
			{			
				//Connect paired device
			}
			break;
		}
	}
}			
			
#pragma mark - Scanning for devices
//Start device scan if the reader is disconnected or reader returns an error while connecting.
- (void)startScan
{
	if(blueToothManager != nil)
	{
		[self initiateBLEDeviceScan];
	}
	
	if(accessoryManager != nil)			
	{
		[self initiateMFIDeviceScan];
	}
}

- (void)stopScan
{
	[blueToothManager stopScan];
	[accessoryManager unregisterForLocalNotifications];
	[[NSNotificationCenter defaultCenter] removeObserver:EAAccessoryDidConnectNotification];
	[[NSNotificationCenter defaultCenter] removeObserver:EAAccessoryDidDisconnectNotification];
}

@end