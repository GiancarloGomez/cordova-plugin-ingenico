#import "CDVIngenico.h"
#import <Cordova/CDV.h>

// used to track is SDK has been initialized
static bool isSDKInitialized     = false;
/**
* @isAutoConnectRequest
* Used throughout the connection process for sending back calls to cordova throught the process
* This is set to true when connect() is invoked and false when selectDevice() is invoked
*/
static bool isAutoConnectRequest = false;
// this is set when a custom device is selected using setDeviceType which then blocks doSetDefaultDeviceType
static bool customDeviceSelected = false;
// when searching for a device this is how long we will search before timing out ( ms )
static long searchDuration       = 5000;

@implementation CDVIngenico

#pragma mark - Cordova Communication
- (void)sendPluginResult:(NSString *)theCallbackID messageAsString:(NSString*)theMessage
{
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:theMessage];
    [self.commandDelegate sendPluginResult:result callbackId:theCallbackID];
}

- (void)sendPluginResult:(NSString *)theCallbackID messageAsString:(NSString*)theMessage keepCallbackAsBool:(BOOL)keepCallbackAsBool
{
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:theMessage];
    if (keepCallbackAsBool)
        [result setKeepCallbackAsBool:YES];
    else
        [result setKeepCallbackAsBool:NO];
    [self.commandDelegate sendPluginResult:result callbackId:theCallbackID];
}

- (void)sendPluginResult:(NSString *)theCallbackID messageAsBool:(BOOL)theMessage
{
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:theMessage];
    [self.commandDelegate sendPluginResult:result callbackId:theCallbackID];
}

- (void)sendPluginResult:(NSString *)theCallbackID messageAsBool:(BOOL)theMessage keepCallbackAsBool:(BOOL)keepCallbackAsBool
{
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:theMessage];
    if (keepCallbackAsBool)
        [result setKeepCallbackAsBool:YES];
    else
        [result setKeepCallbackAsBool:NO];
    [self.commandDelegate sendPluginResult:result callbackId:theCallbackID];
}

- (void)sendPluginResult:(NSString *)theCallbackID messageAsNSInteger:(NSInteger)theMessage
{
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsNSInteger:theMessage];
    [self.commandDelegate sendPluginResult:result callbackId:theCallbackID];
}

- (void)sendPluginError:(NSString *)theCallbackID messageAsNSInteger:(NSInteger)theMessage
{
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:theMessage];
    [self.commandDelegate sendPluginResult:result callbackId:theCallbackID];
}

- (void)sendPluginError:(NSString *)theCallbackID messageAsNSInteger:(NSInteger)theMessage keepCallbackAsBool:(BOOL)keepCallbackAsBool
{
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsNSInteger:theMessage];
    if (keepCallbackAsBool)
        [result setKeepCallbackAsBool:YES];
    else
        [result setKeepCallbackAsBool:NO];
    [self.commandDelegate sendPluginResult:result callbackId:theCallbackID];
}

- (void)sendPluginError:(NSString *)theCallbackID messageAsString:(NSString*)theMessage
{
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:theMessage];
    [self.commandDelegate sendPluginResult:result callbackId:theCallbackID];
}

#pragma mark - Authentication
- (void)initialize:(CDVInvokedUrlCommand*)command
{
    // initialize SDK
    if ( !isSDKInitialized )
    {
        #ifdef DEBUG_MODE
            NSLog(@"initialize()");
        #endif
        apiKey        = [command.arguments objectAtIndex:0];
        baseURL       = [command.arguments objectAtIndex:1];
        clientVersion = [command.arguments objectAtIndex:2];
        [self doInitializeSDK];
    }
    [self sendPluginResult:command.callbackId messageAsBool:isSDKInitialized];
}

- (void)login:(CDVInvokedUrlCommand*)command
{
    if ( [self doCanExecute:command.callbackId requiresLogin:false] )
    {
        // if not logged in
        if ( ![self doIsLoggedIn] )
        {
            #ifdef DEBUG_MODE
                NSLog(@"login() -> authenticate");
            #endif
            NSString *uname = [command.arguments objectAtIndex:0];
            NSString *pw    = [command.arguments objectAtIndex:1];
            // fix if what we received is a number in username or password
            if ([uname isKindOfClass:[NSNumber class]])
                uname = [NSString stringWithFormat:@"%@", uname];
            if ([pw isKindOfClass:[NSNumber class]])
                pw = [NSString stringWithFormat:@"%@", pw];
            // login and validate user authenticity to use the application
            [[[Ingenico sharedInstance] User] loginwithUsername:uname andPassword:pw onResponse:^(IMSUserProfile *user, NSError *error) {
                if( !error ){
                    self->userProfile = user;
                    [self doReturnUserProfile:command.callbackId];
                }
                else
                {
                    if ( error.code == InvalidAPIKey )
                        isSDKInitialized = false;
                    [self sendPluginError:command.callbackId messageAsNSInteger:error.code];
                }
            }];
        }
        // return user profile
        else
        {
            [self doReturnUserProfile:command.callbackId];
        }
    }
}

- (void)logoff:(CDVInvokedUrlCommand*)command
{
    if ( [self doCanExecute:command.callbackId requiresLogin:false] )
    {
        // process logoff
        if ( [self doIsLoggedIn] )
        {
            #ifdef DEBUG_MODE
                NSLog(@"logoff()");
            #endif
            [[Ingenico sharedInstance].User logoff:^(NSError *error) {
               if( !error )
                {
                    bool deviceConnected = [[[Ingenico sharedInstance] PaymentDevice] isConnected];
                    #ifdef DEBUG_MODE
                        NSLog(@"Device connected at logoff = %d",deviceConnected);
                    #endif
                    // disconnect device if one connected
                    if (deviceConnected)
                        [[Ingenico sharedInstance].PaymentDevice releaseDevice:self];
                    [self sendPluginResult:command.callbackId messageAsBool:true];
                }
                else
                {
                    [self sendPluginError:command.callbackId messageAsNSInteger:error.code];
                }
                // reset userProfile
                self->userProfile = nil;
            }];
        }
        // return false if not logged in
        else
        {
            [self sendPluginResult:command.callbackId messageAsBool:false];
        }
    }
}

- (void)refreshUserSession:(CDVInvokedUrlCommand*)command
{
    if ( [self doCanExecute:command.callbackId requiresLogin:false] )
    {
        if ( [self doIsLoggedIn] )
        {
            #ifdef DEBUG_MODE
                NSLog(@"refreshUserSession()");
            #endif
            [[Ingenico sharedInstance].User refreshUserSession:^(IMSUserProfile *user, NSError *error) {
                if( !error )
                {
                    self->userProfile = user;
                    [self doReturnUserProfile:command.callbackId];
                }
                else
                {
                    [self sendPluginError:command.callbackId messageAsNSInteger:error.code];
                }
            }];
        }
        // return false if not logged in
        else
        {
            [self sendPluginResult:command.callbackId messageAsBool:false];
        }
    }
}

- (void)isInitialized:(CDVInvokedUrlCommand*)command
{
   [self sendPluginResult:command.callbackId messageAsBool:isSDKInitialized];
}

- (void)isLoggedIn:(CDVInvokedUrlCommand*)command
{
    #ifdef DEBUG_MODE
        NSLog(@"isLoggedIn");
    #endif
    if ( [self doCanExecute:command.callbackId requiresLogin:false] )
        [self sendPluginResult:command.callbackId messageAsBool:[self doIsLoggedIn]];
}

#pragma mark - Authentication Helpers

- (void)doInitializeSDK
{
    #ifdef DEBUG_MODE
        NSLog(@"doInitializeSDK");
    #endif
    [[Ingenico sharedInstance] initializeWithBaseURL:baseURL apiKey:apiKey clientVersion:clientVersion];
    // set up our supported devices
    [self doSetSupportedDevices];
    // set the default device that can be changed with setDeviceType
    [self doSetDefaultDeviceType];
    isSDKInitialized = true;
}

- (bool)doIsLoggedIn
{
    #ifdef DEBUG_MODE
    NSLog(@"doIsLoggedIn");
    #endif
    bool loggedIn = false;
    if ( isSDKInitialized && userProfile )
    {
        NSDate *localTime= [NSDate date];
        // set formatter to work with expires time
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
        // set formatter to UTC as time is GMT from Ingenico
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        // create timeout date from userProfile.session.expiresTime
        NSDate *timeoutDate = [dateFormatter dateFromString:userProfile.session.expiresTime];
        // change formatter time zone to local ( does the change automatically )
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        #ifdef DEBUG_MODE
        NSLog(@"%@",userProfile.session.expiresTime);
        NSLog(@"Local Time @ => %@",localTime);
        NSLog(@"Session Expires @ => %@",timeoutDate);
        #endif
        // compare our dates
        NSComparisonResult result = [localTime compare:timeoutDate];
        loggedIn = result == NSOrderedAscending;
    }
    // reset userProfile if not logged in but userProfile is not nil
    if (!loggedIn && userProfile)
        userProfile = nil;
    // return boolean
    return loggedIn;
}

- (void)doReturnUserProfile:(NSString *)theCallbackID
{
    #ifdef DEBUG_MODE
        NSLog(@"doReturnUserProfile");
        NSLog(@"%@",userProfile.session);
    #endif
    NSString *JSONResponse = [userProfile JSONString];
    [self sendPluginResult:theCallbackID messageAsString:JSONResponse];
}

#pragma mark - Device Information

- (void)getBatteryLevel:(CDVInvokedUrlCommand*)command;
{
    #ifdef DEBUG_MODE
        NSLog(@"getBatteryLevel()");
    #endif
    if ( [self doCanExecute:command.callbackId requiresLogin:false] )
    {
        [[Ingenico sharedInstance].PaymentDevice getDeviceBatteryLevel:^(NSInteger batteryLevel, NSError *error) {
            if( !error )
                [self sendPluginResult:command.callbackId messageAsNSInteger:batteryLevel];
            else
                [self sendPluginError:command.callbackId messageAsNSInteger:error.code];
        }];
    }
}

- (void)getDeviceType:(CDVInvokedUrlCommand*)command;
{
    #ifdef DEBUG_MODE
        NSLog(@"getDeviceType()");
    #endif
    if ( [self doCanExecute:command.callbackId requiresLogin:false] )
    {
        RUADeviceType _deviceType = [[Ingenico sharedInstance].PaymentDevice getType];
        [self sendPluginResult:command.callbackId messageAsNSInteger:_deviceType];
    }
}

- (void)getDeviceSerialNumber:(CDVInvokedUrlCommand*)command;
{
    if ( [self doCanExecute:command.callbackId requiresLogin:false] )
    {
        [[Ingenico sharedInstance].PaymentDevice getDeviceSerialNumber:^(NSString *serialNumber, NSError *error) {
            if( !error )
                [self sendPluginResult:command.callbackId messageAsString:serialNumber];
            else
                [self sendPluginError:command.callbackId messageAsNSInteger:error.code];
        }];
    }
}

#pragma mark - Device Connection and Setup

// search -> select and initialize
// auto selects and initializes first valid device found
- (void)connect:(CDVInvokedUrlCommand*)command
{
    #ifdef DEBUG_MODE
        NSLog(@"connect()");
    #endif
    if ([self doCanExecute:command.callbackId requiresLogin:false])
    {
        isAutoConnectRequest = true;
        [self doSearchForDevice:command.callbackId];
    }
}

// manual disconnect -> fires off done()
- (void)disconnect:(CDVInvokedUrlCommand*)command
{
    #ifdef DEBUG_MODE
        NSLog(@"disconnect()");
    #endif
    if ( [self doCanExecute:command.callbackId requiresLogin:false] )
    {
        bool deviceConnected = [[[Ingenico sharedInstance] PaymentDevice] isConnected];
        if ( deviceConnected )
            [[Ingenico sharedInstance].PaymentDevice releaseDevice:self];
        [self sendPluginResult:command.callbackId messageAsBool:deviceConnected];
    }
}

- (void)isDeviceConnected:(CDVInvokedUrlCommand*)command
{
    #ifdef DEBUG_MODE
        NSLog(@"isDeviceConnected()");
    #endif
    if ( [self doCanExecute:command.callbackId requiresLogin:false] )
    {
        bool deviceConnected = [[[Ingenico sharedInstance] PaymentDevice] isConnected];
        [self sendPluginResult:command.callbackId messageAsBool:deviceConnected];
    }
}

// select and initialize a device
// passed in from a search result
- (void)selectDevice:(CDVInvokedUrlCommand*)command
{
    #ifdef DEBUG_MODE
        NSLog(@"selectDevice()");
    #endif
    if ([self doCanExecute:command.callbackId requiresLogin:false])
    {
        connectCallbackID       = command.callbackId;
        NSString *deviceJSON    = [command.arguments objectAtIndex:0];
        RUADevice *deviceIn     = [RUADevice objectWithJSONString:deviceJSON];
        bool deviceSeleted      = false;
        for( RUADevice *device in deviceList )
        {
            if( [device.identifier isEqualToString:deviceIn.identifier] )
            {
                [[Ingenico sharedInstance].PaymentDevice select:device];
                [[Ingenico sharedInstance].PaymentDevice initialize:self];
                deviceSeleted = true;
                break;
            }
        }
        [self sendPluginResult:self->connectCallbackID messageAsBool:deviceSeleted keepCallbackAsBool:deviceSeleted];
    }
}

- (void)setDeviceType:(CDVInvokedUrlCommand*)command
{
    #ifdef DEBUG_MODE
        NSLog(@"setDeviceType()");
    #endif
    if ([self doCanExecute:command.callbackId requiresLogin:false])
    {
        NSString *deviceType = [command.arguments objectAtIndex:0];
        bool deviceSupported = false;
        // check if deviceType sent is supported
        for ( id supportedDevice in supportedDevices )
        {
            #ifdef DEBUG_MODE
                NSLog(@"%@ %@",deviceType,supportedDevice);
            #endif
            if ( [deviceType containsString:supportedDevice] )
            {
                #ifdef DEBUG_MODE
                    NSLog(@"We have a match");
                #endif
                deviceSupported = true;
                break;
            }
        }
        // continue to set if device supported
        if ( deviceSupported )
        {
            if ( [deviceType isEqualToString:@"RUADeviceTypeRP450c"] )
                [[Ingenico sharedInstance].PaymentDevice setDeviceType:RUADeviceTypeRP450c];
            else if ( [deviceType isEqualToString:@"RUADeviceTypeRP750x"] )
                [[Ingenico sharedInstance].PaymentDevice setDeviceType:RUADeviceTypeRP750x];
            else if ( [deviceType isEqualToString:@"RUADeviceTypeMOBY3000"] )
                [[Ingenico sharedInstance].PaymentDevice setDeviceType:RUADeviceTypeMOBY3000];
            else if ( [deviceType isEqualToString:@"RUADeviceTypeMOBY8500"] )
                [[Ingenico sharedInstance].PaymentDevice setDeviceType:RUADeviceTypeMOBY8500];
            else
                deviceSupported = false;
        }
        // mark that specific device set
        customDeviceSelected = deviceSupported;
        // respond
        [self sendPluginResult:command.callbackId messageAsBool:deviceSupported];
    }
}

// setup the selected and initialized device
- (void)setupDevice:(CDVInvokedUrlCommand*)command
{
    #ifdef DEBUG_MODE
        NSLog(@"doSetupDevice()");
    #endif

    [[[Ingenico sharedInstance] PaymentDevice] checkDeviceSetup:^(NSError *error,bool isSetupRequired) {
        if( !error )
        {
            #ifdef DEBUG_MODE
                NSLog(@"doSetupDevice()->isRequired");
            #endif
            if(isSetupRequired)
            {
                #ifdef DEBUG_MODE
                    NSLog(@"=> SetupRequired");
                #endif
                [[Ingenico sharedInstance].PaymentDevice setup:^(NSError *error) {
                    if( !error )
                    {
                        [self sendPluginResult:command.callbackId messageAsString:@"ready"];
                    }
                    else
                    {
                        #ifdef DEBUG_MODE
                            NSLog(@"doSetupDevice()->Error-> %ld : %@",(long)error.code,error.description);
                        #endif
                        [self sendPluginError:command.callbackId messageAsNSInteger:error.code];
                    }
                }];
            }
            else
            {
                #ifdef DEBUG_MODE
                    NSLog(@"=> SetupNotRequired");
                #endif
                [self sendPluginResult:command.callbackId messageAsString:@"ready"];
            }
        }
        else
        {
            #ifdef DEBUG_MODE
                NSLog(@"doSetupDevice()->Error-> %ld : %@",(long)error.code,error.description);
            #endif
            [self sendPluginError:command.callbackId messageAsNSInteger:error.code];
        }
    }];
}

- (void)configureIdleShutdownTimeout:(CDVInvokedUrlCommand *)command
{
    if ([self doCanExecute:command.callbackId requiresLogin:false])
    {
        NSNumber *timeoutInSeconds = [command.arguments objectAtIndex:0];
        int timeoutInSecondsInt = [timeoutInSeconds intValue];

        #ifdef DEBUG_MODE
                NSLog(@"configureIdleShutdownTimeout(%@)",timeoutInSeconds);
        #endif

        [[[Ingenico sharedInstance] PaymentDevice] configureIdleShutdownTimeout:timeoutInSecondsInt andOnDone:^(NSError * _Nullable error) {
            if( !error )
            {
                [self sendPluginResult:command.callbackId messageAsBool:true];
            }
            else
            {
                [self sendPluginError:command.callbackId messageAsNSInteger:error.code];
            }
        }];
    }
}

#pragma mark - Connection Status Handlers

// Invoked when the reader is connected
- (void)onConnected
{
    #ifdef DEBUG_MODE
        NSLog(@"onConnected()");
    #endif
    [self sendPluginResult:self->connectCallbackID messageAsString:@"connected" keepCallbackAsBool:true];
}

// Invoked when the reader is disconnected
- (void)onDisconnected
{
    #ifdef DEBUG_MODE
        NSLog(@"onDisconnected()");
    #endif
    [self sendPluginResult:self->connectCallbackID messageAsString:@"disconnected" keepCallbackAsBool:false];
}

// Invoked when the reader returns an error while connecting
- (void)onError:(NSString *)message
{
    #ifdef DEBUG_MODE
        NSLog(@"onError() -> %@",message);
    #endif
    [self doSearchForDevice:self->connectCallbackID];
}

// Invoked when a device manager releases all the resources it acquired ( manual disconnect )
// This requires an SDK reinit and login
- (void)done
{
    #ifdef DEBUG_MODE
        NSLog(@"done()");
    #endif
    userProfile = nil;
    isSDKInitialized = false;
    [self doInitializeSDK];
}

#pragma mark - Device Search

- (void)searchForDevice:(CDVInvokedUrlCommand*)command
{
    #ifdef DEBUG_MODE
        NSLog(@"searchForDevice()");
    #endif
    if ([self doCanExecute:command.callbackId requiresLogin:false])
    {
        isAutoConnectRequest = false;
        [self doSearchForDevice:command.callbackId];
    }
}

- (void)stopSearchForDevice:(CDVInvokedUrlCommand*)command
{
    #ifdef DEBUG_MODE
        NSLog(@"stopSearchForDevice()");
    #endif
    if ([self doCanExecute:command.callbackId requiresLogin:false])
    {
        [self doStopSearch];
        [self sendPluginResult:command.callbackId messageAsBool:true];
    }
}

#pragma mark - Device Search Helpers

// Invoked by connect, searchForDevice and onError
- (void)doSearchForDevice:(NSString *)theCallbackID
{
    #ifdef DEBUG_MODE
        NSLog(@"doSearchForDevice()");
    #endif
    @try
    {
        [[Ingenico sharedInstance].PaymentDevice searchForDuration:searchDuration andListener:self];
        // set callback id to use throughout process
        connectCallbackID = theCallbackID;
        // reset device list to empty array
        deviceList = [[NSMutableArray alloc] init];
    }
    @catch ( NSException *e )
    {
        [self sendPluginError:theCallbackID messageAsString:e.reason];
    }
}

// Invoked by stopSearchForDevice
- (void)doStopSearch
{
    #ifdef DEBUG_MODE
        NSLog(@"stopSearch()");
    #endif
    [[Ingenico sharedInstance].PaymentDevice stopSearch];
}

#pragma mark - Search Listeners

- (void)discoveredDevice:(RUADevice *)reader
{
    // only work with results with a name and identifier
    if(reader.name && reader.identifier)
    {
        bool isIncluded = false;
        bool addToList  = false;
        // if device is already in list break out
        for( RUADevice *device in deviceList )
        {
            if( [device.identifier isEqualToString:reader.identifier] )
            {
                isIncluded = true;
                break;
            }
        }
        // only add devices that match any of the following types
        NSArray  *deviceArray = [reader.name componentsSeparatedByString:@"-"];
        NSString *deviceType  = deviceArray[0];
        // check if device is in allowed devices
        if ( [supportedDevices containsObject:deviceType] )
            addToList = true;
        // add to list if validates
        if ( !isIncluded && addToList )
        {
            #ifdef DEBUG_MODE
                NSLog(@"discoveredDevice() -> %@",reader.name);
            #endif
            [deviceList addObject:reader];
        }
    }
}

// on auto connect (initialize + setup) | on search return device array
- (void)discoveryComplete
{
    if ( isAutoConnectRequest )
    {
        #ifdef DEBUG_MODE
            NSLog(@"discoveryComplete() => Auto Connect Lookup Result %lu",(unsigned long)[deviceList count]);
        #endif
        if ( [deviceList count] > 0 )
        {
            #ifdef DEBUG_MODE
                NSLog(@"Selecting device");
            #endif
            RUADevice *device = deviceList[0];
            [[Ingenico sharedInstance].PaymentDevice select:device];
            [[Ingenico sharedInstance].PaymentDevice initialize:self];
            [self sendPluginResult:self->connectCallbackID messageAsString:@"selected" keepCallbackAsBool:true];
        }
        else
        {
            [self sendPluginResult:self->connectCallbackID messageAsBool:false keepCallbackAsBool:false];
        }
    }
    else
    {
        #ifdef DEBUG_MODE
            NSLog(@"discoveryComplete() => Manual Lookup");
        #endif
        NSString *JSONResponse = [deviceList JSONString];
        [self sendPluginResult:self->connectCallbackID messageAsString:JSONResponse keepCallbackAsBool:false];
    }
}

#pragma mark - Transactions

- (void)processCashTransaction:(CDVInvokedUrlCommand*)command
{
    #ifdef DEBUG_MODE
        NSLog(@"processCashTransaction()");
    #endif
    if ([self doCanExecute:command.callbackId requiresLogin:true])
    {
        @try
        {
            NSString *amountJSON         = [command.arguments objectAtIndex:0];
            NSString *transactionGroupID = [command.arguments objectAtIndex:1];
            NSString *transactionNotes   = [command.arguments objectAtIndex:2];
            // prepare for transaction
            transactionGroupID = [transactionGroupID isEqual:[NSNull null]] ? nil : transactionGroupID;
            transactionNotes   = [transactionNotes isEqual:[NSNull null]] ? nil : transactionNotes;
            IMSAmount *amount  = [IMSAmount objectWithJSONString:amountJSON];

            IMSCashSaleTransactionRequest *request = [[IMSCashSaleTransactionRequest alloc] initWithAmount:amount
                                                                                               andProducts:nil
                                                                                                andClerkID:nil
                                                                                              andLongitude:nil
                                                                                               andLatitude:nil
                                                                                     andTransactionGroupID:transactionGroupID
                                                                                       andTransactionNotes:transactionNotes
                                                                                      andMerchantInvoiceID:nil
                                                                           andShowNotesAndInvoiceOnReceipt:false ];

            [[Ingenico sharedInstance].Payment processCashTransaction:request andOnDone:^(IMSTransactionResponse *response, NSError *error)
            {
                 if( !error )
                 {
                     NSString *JSONResponse = [response JSONString];
                     [self sendPluginResult:command.callbackId messageAsString:JSONResponse];
                 }
                 else
                 {
                     [self sendPluginError:command.callbackId messageAsNSInteger:error.code];
                 }
            }];
        }
        @catch ( NSException *e )
        {
           [self sendPluginError:command.callbackId messageAsString:e.reason];
        }
    }
}

- (void)processCreditSaleTransactionWithCardReader:(CDVInvokedUrlCommand*)command
{
    #ifdef DEBUG_MODE
        NSLog(@"processCreditSaleTransactionWithCardReader()");
    #endif
    if ([self doCanExecute:command.callbackId requiresLogin:true])
    {
        @try
        {
            NSString *amountJSON         = [command.arguments objectAtIndex:0];
            NSString *transactionGroupID = [command.arguments objectAtIndex:1];
            NSString *transactionNotes   = [command.arguments objectAtIndex:2];
            // prepare for transaction
            transactionGroupID = [transactionGroupID isEqual:[NSNull null]] ? nil : transactionGroupID;
            transactionNotes   = [transactionNotes isEqual:[NSNull null]] ? nil : transactionNotes;
            IMSAmount *amount  = [IMSAmount objectWithJSONString:amountJSON];

            IMSCreditSaleTransactionRequest *request = [[IMSCreditSaleTransactionRequest alloc] initWithAmount:amount
                                                                                                   andProducts:nil
                                                                                                    andClerkID:nil
                                                                                                  andLongitude:nil
                                                                                                   andLatitude:nil
                                                                                         andTransactionGroupID:transactionGroupID
                                                                                           andTransactionNotes:transactionNotes
                                                                                          andMerchantInvoiceID:nil
                                                                               andShowNotesAndInvoiceOnReceipt:false ];

            [[Ingenico sharedInstance].Payment processCreditSaleTransactionWithCardReader:request
                                                                        andUpdateProgress:^(IMSProgressMessage message, NSString *extraMessage) { }
                                                                     andSelectApplication:^(NSArray *applicationList, NSError *error, ApplicationSelectedResponse appReponse) {
                                                                         appReponse((RUAApplicationIdentifier *)[applicationList objectAtIndex:0]);
                                                                     }
                                                                                andOnDone:^(IMSTransactionResponse *response, NSError *error)
            {
                if( !error )
                {
                    NSString *JSONResponse = [response JSONString];
                    [self sendPluginResult:command.callbackId messageAsString:JSONResponse];
                }
                else
                {
                    [self sendPluginError:command.callbackId messageAsNSInteger:error.code];
                }
            }];
        }
        @catch ( NSException *e )
        {
            [self sendPluginError:command.callbackId messageAsString:e.reason];
        }
    }
}

- (void)processDebitSaleTransactionWithCardReader:(CDVInvokedUrlCommand*)command
{
    #ifdef DEBUG_MODE
        NSLog(@"processDebitSaleTransactionWithCardReader()");
    #endif
    if ([self doCanExecute:command.callbackId requiresLogin:true])
    {
        @try
        {
            NSString *amountJSON         = [command.arguments objectAtIndex:0];
            NSString *transactionGroupID = [command.arguments objectAtIndex:1];
            NSString *transactionNotes   = [command.arguments objectAtIndex:2];
            // prepare for transaction
            transactionGroupID = [transactionGroupID isEqual:[NSNull null]] ? nil : transactionGroupID;
            transactionNotes   = [transactionNotes isEqual:[NSNull null]] ? nil : transactionNotes;
            IMSAmount *amount  = [IMSAmount objectWithJSONString:amountJSON];

            IMSDebitSaleTransactionRequest *request = [[IMSDebitSaleTransactionRequest alloc] initWithAmount:amount
                                                                                                 andProducts:nil
                                                                                                  andClerkID:nil
                                                                                                andLongitude:nil
                                                                                                 andLatitude:nil
                                                                                       andTransactionGroupID:transactionGroupID
                                                                                         andTransactionNotes:transactionNotes
                                                                                        andMerchantInvoiceID:nil
                                                                             andShowNotesAndInvoiceOnReceipt:false ];

            [[Ingenico sharedInstance].Payment processDebitSaleTransactionWithCardReader:request
                                                                       andUpdateProgress:^(IMSProgressMessage message, NSString *extraMessage) { }
                                                                    andSelectApplication:^(NSArray *applicationList, NSError *error, ApplicationSelectedResponse appReponse) {
                                                                        appReponse((RUAApplicationIdentifier *)[applicationList objectAtIndex:0]);
                                                                    }
                                                                               andOnDone:^(IMSTransactionResponse *response, NSError *error)
            {
                if( !error )
                {
                    NSString *JSONResponse = [response JSONString];
                    [self sendPluginResult:command.callbackId messageAsString:JSONResponse];
                }
                else
                {
                    [self sendPluginError:command.callbackId messageAsNSInteger:error.code];
                }
            }];
        }
        @catch ( NSException *e )
        {
            [self sendPluginError:command.callbackId messageAsString:e.reason];
        }
    }
}

#pragma mark - Helpers

- (bool)doCanExecute:(NSString *)theCallbackID requiresLogin:(bool)loginRequired
{
    bool canExecute = isSDKInitialized && (!loginRequired || userProfile);
    #ifdef DEBUG_MODE
        NSLog(@"doCanExecute( %@ )",canExecute ? @"YES" : @"NO");
    #endif
    // send error if can not execute
    if ( !canExecute )
    {
        if ( loginRequired )
            [self sendPluginError:theCallbackID messageAsString:@"Initialize SDK and Login"];
        else
            [self sendPluginError:theCallbackID messageAsNSInteger:4981];
    }
    return canExecute;
}

- (void)doSetSupportedDevices
{
    // setup supported devices if not yet set
    if ( !supportedDevices )
    {
        #ifdef DEBUG_MODE
            NSLog(@"doSetSupportedDevices()");
        #endif
        supportedDevices = @[@"RP450",@"RP750",@"MOBY3000",@"MOBY8500"];
    }
}

- (void)doSetDefaultDeviceType
{
    // set default device type to RUADeviceTypeRP750x unless a custom device was selected by setDeviceType
    if ( !customDeviceSelected )
    {
        #ifdef DEBUG_MODE
            NSLog(@"doSetDefaultDeviceType()");
        #endif
        [[Ingenico sharedInstance].PaymentDevice setDeviceType:RUADeviceTypeRP750x];
    }
}

@end
