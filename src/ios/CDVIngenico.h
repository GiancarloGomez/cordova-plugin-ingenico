#import "CollectionFactory.h"
#import "DeviceManagementHelper.h"
#import <Cordova/CDV.h>
#import <IngenicoMposSdk/Ingenico.h>
#import <AVFoundation/AVFoundation.h>
#import <LocalAuthentication/LocalAuthentication.h>

@interface CDVIngenico : CDVPlugin <RUADeviceSearchListener, RUAReleaseHandler, RUADeviceStatusHandler>
{
    // used to initialize SDK
    NSString *apiKey;
    NSString *baseURL;
    NSString *clientVersion;
    // set by doSearchDevice ( auto connect and manual search prior to select )
    // and selectDevice ( manual selection )
    NSString *connectCallbackID;
    // stores list of available devices
    NSMutableArray *deviceList;
    // stores the supported devices
    NSArray *supportedDevices;
    // stores saved user profile from a login or refresh
    IMSUserProfile *userProfile;
}
// Cordova Communication
- (void)sendPluginResult:(NSString *)theCallbackID messageAsString:(NSString *)theMessage;
- (void)sendPluginResult:(NSString *)theCallbackID messageAsString:(NSString *)theMessage keepCallbackAsBool:(BOOL)keepCallbackAsBool;
- (void)sendPluginResult:(NSString *)theCallbackID messageAsBool:(BOOL)theMessage;
- (void)sendPluginResult:(NSString *)theCallbackID messageAsBool:(BOOL)theMessage keepCallbackAsBool:(BOOL)keepCallbackAsBool;
- (void)sendPluginResult:(NSString *)theCallbackID messageAsNSInteger:(NSInteger)theMessage;
- (void)sendPluginError:(NSString *)theCallbackID messageAsNSInteger:(NSInteger)theMessage;
- (void)sendPluginError:(NSString *)theCallbackID messageAsNSInteger:(NSInteger)theMessage keepCallbackAsBool:(BOOL)keepCallbackAsBool;
- (void)sendPluginError:(NSString *)theCallbackID messageAsString:(NSString *)theMessage;
// Authentication
- (void)initialize:(CDVInvokedUrlCommand *)command;
- (void)login:(CDVInvokedUrlCommand *)command;
- (void)logoff:(CDVInvokedUrlCommand *)command;
- (void)refreshUserSession:(CDVInvokedUrlCommand *)command;
- (void)isInitialized:(CDVInvokedUrlCommand *)command;
- (void)isLoggedIn:(CDVInvokedUrlCommand *)command;
// Authentication Helpers
- (void)doInitializeSDK;
- (bool)doIsLoggedIn;
- (void)doReturnUserProfile:(NSString *)theCallbackID;
// Device Information
- (void)getBatteryLevel:(CDVInvokedUrlCommand *)command;
- (void)getDeviceSerialNumber:(CDVInvokedUrlCommand *)command;
- (void)getDeviceType:(CDVInvokedUrlCommand *)command;
// Device Connection
- (void)connect:(CDVInvokedUrlCommand *)command;
- (void)disconnect:(CDVInvokedUrlCommand *)command;
- (void)isDeviceConnected:(CDVInvokedUrlCommand *)command;
// Connection Status Handlers
- (void)onConnected;
- (void)onDisconnected;
- (void)onError:(NSString *)message;
// Device Setup
- (void)setDeviceType:(CDVInvokedUrlCommand *)command;
- (void)selectDevice:(CDVInvokedUrlCommand *)command;
// Device Setup Helpers
- (void)doSetupDevice;
// Device Search
- (void)searchForDevice:(CDVInvokedUrlCommand *)command;
- (void)stopSearchForDevice:(CDVInvokedUrlCommand *)command;
// Device Search Helpers
- (void)doSearchForDevice:(NSString *)theCallbackID; // try/catch
- (void)doStopSearch;
// Search Listeners
- (void)discoveredDevice:(RUADevice *)reader;
- (void)discoveryComplete;
// Transactions
- (void)processCashTransaction:(CDVInvokedUrlCommand *)command;                     // try/catch
- (void)processCreditSaleTransactionWithCardReader:(CDVInvokedUrlCommand *)command; // try/catch
- (void)processDebitSaleTransactionWithCardReader:(CDVInvokedUrlCommand *)command;  // try/catch
// Helpers
- (bool)doCanExecute:(NSString *)theCallbackID requiresLogin:(bool)loginRequired;
- (void)doSetSupportedDevices;
- (void)doSetDefaultDeviceType;
@end
