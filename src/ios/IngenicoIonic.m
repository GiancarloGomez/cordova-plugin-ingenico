/********* IngenicoIonic.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import <IngenicoMposSdk/Ingenico.h>
#import <AVFoundation/AVFoundation.h>
#import <LocalAuthentication/LocalAuthentication.h>

#import "CollectionFactory.h"
#import "DeviceManagementHelper.h"
//#import <CollectionFactory/CollectionFactory.h>

static bool isDeviceConnected = NO;
static bool isConnectingState = NO;
static bool keepSearchingDevices = NO;
static RUADeviceType _connectingDeviceType;
static RUADevice *_connectingDevice;

static NSString *clientVersion = nil;
static NSString *baseURL = nil;
static NSString *apiKey = nil;

@interface IngenicoIonic : CDVPlugin {
  // Member variables go here.
  NSString *callbackId;
  NSString *searchCallbackId;
  NSString *deviceDisconnectedCallbackId;
  NSMutableArray *deviceList;
}

- (void)login:(CDVInvokedUrlCommand*)command;
- (void)connect:(CDVInvokedUrlCommand*)command;
- (void)onDeviceDisconnected:(CDVInvokedUrlCommand*)command;
- (void)setDeviceType:(CDVInvokedUrlCommand*)command;
- (void)searchForDevice:(CDVInvokedUrlCommand*)command;
- (void)stopSearchForDevice:(CDVInvokedUrlCommand*)command;
- (void)selectDevice:(CDVInvokedUrlCommand*)command;
- (void)setupDevice:(CDVInvokedUrlCommand*)command;
- (void)doSetupDevice:(NSString*)callbackId;

- (void)processCashTransaction:(CDVInvokedUrlCommand*)command;
- (void)processCreditSaleTransactionWithCardReader:(CDVInvokedUrlCommand*)command;
- (void)processDebitSaleTransactionWithCardReader:(CDVInvokedUrlCommand*)command;

- (void)getReferenceForTransactionWithPendingSignature:(CDVInvokedUrlCommand*)command;
- (void)uploadSignature:(CDVInvokedUrlCommand*)command;

- (void)initiateScan:(CDVInvokedUrlCommand*)command;
@end

@implementation IngenicoIonic

- (void)login:(CDVInvokedUrlCommand*)command
 {
    clientVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"IngenicomPosSDKClientVersion"];
    baseURL = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"IngenicomPosSDKBaseUrl"];
    apiKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"IngenicomPosSDKAPIKey"];

    [[Ingenico sharedInstance]
    initializeWithBaseURL:baseURL apiKey:apiKey clientVersion:clientVersion];

    NSString *uname = [command.arguments objectAtIndex:0];
    NSString *pw = [command.arguments objectAtIndex:1];

    [[[Ingenico sharedInstance] User] loginwithUsername:uname andPassword:pw onResponse:^(IMSUserProfile *user, NSError *error) {
        
        CDVPluginResult* pluginResult = nil;
        if(!error){
            NSString *JSONuser = [user JSONString];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:JSONuser];  
                  
        } else {          
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.localizedDescription];
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
 }

- (void)connect:(CDVInvokedUrlCommand*)command
{
    NSLog(@"Connect");
    CDVPluginResult* pluginResult = nil;
    @try {                                             
        [[Ingenico sharedInstance].PaymentDevice setDeviceType:RUADeviceTypeRP750x];  // It is indicated by default to start the search. Then the type is indicated depending on the selected device
        [[Ingenico sharedInstance].PaymentDevice search:self];
        searchCallbackId = command.callbackId;
        deviceList = [[NSMutableArray alloc] init];
        isConnectingState = YES;
        keepSearchingDevices = YES;
    }
    @catch ( NSException *e ) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:e.reason];   
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }    
}

- (void)onDeviceDisconnected:(CDVInvokedUrlCommand*)command
{
    NSLog(@"OnDeviceDisconnected");
    deviceDisconnectedCallbackId = command.callbackId;

}

- (void)setDeviceType:(CDVInvokedUrlCommand*)command
{    
    CDVPluginResult* pluginResult = nil;
    NSString *deviceType = [command.arguments objectAtIndex:0];
    bool ok = false;
  
    if ([deviceType isEqualToString:@"RUADeviceTypeG4x"]){
        [[Ingenico sharedInstance].PaymentDevice setDeviceType:RUADeviceTypeG4x]; 
        ok = true;                               
    } else if ([deviceType isEqualToString:@"RUADeviceTypeRP45BT"]){
        [[Ingenico sharedInstance].PaymentDevice setDeviceType:RUADeviceTypeRP45BT]; 
        ok = true;                               
    } else if ([deviceType isEqualToString:@"RUADeviceTypeRP350x"]){
        [[Ingenico sharedInstance].PaymentDevice setDeviceType:RUADeviceTypeRP350x]; 
        ok = true;                       
    } else if ([deviceType isEqualToString:@"RUADeviceTypeRP450c"]){
        [[Ingenico sharedInstance].PaymentDevice setDeviceType:RUADeviceTypeRP450c]; 
        ok = true;                       
    } else if ([deviceType isEqualToString:@"RUADeviceTypeRP750x"]){
        [[Ingenico sharedInstance].PaymentDevice setDeviceType:RUADeviceTypeRP750x]; 
        ok = true;                       
    } else if ([deviceType isEqualToString:@"RUADeviceTypeMOBY3000"]){
        [[Ingenico sharedInstance].PaymentDevice setDeviceType:RUADeviceTypeMOBY3000]; 
        ok = true;                       
    } else if ([deviceType isEqualToString:@"RUADeviceTypeMOBY8500"]){
        [[Ingenico sharedInstance].PaymentDevice setDeviceType:RUADeviceTypeMOBY8500]; 
        ok = true;                       
    } else {
        [[Ingenico sharedInstance].PaymentDevice setDeviceType:nil];
        ok = true;
    }

    if (ok == true){
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"true"]; 
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:deviceType];   
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId]  ;
}

- (void)searchForDevice:(CDVInvokedUrlCommand*)command
{    
    [self doSearchForDevice:command.callbackId];  
}

- (void)doSearchForDevice:(NSString *)callbackId
{
    CDVPluginResult* pluginResult = nil;
    @try {                                             
        [[Ingenico sharedInstance].PaymentDevice search:self];
        searchCallbackId = callbackId;
        deviceList = [[NSMutableArray alloc] init];
    }
    @catch ( NSException *e ) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:e.reason];   
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
    }    
}

- (void)stopSearchForDevice:(CDVInvokedUrlCommand*)command
{
    NSLog(@"StopSearchForDevice");
    keepSearchingDevices = NO;

    CDVPluginResult* pluginResult = nil;

    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"true"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId]  ;
}

#pragma RUAStatusHandler implementation

- (void)onConnected {
    NSLog(@"Connected");
    CDVPluginResult* pluginResult = nil;    

    if (isConnectingState == YES) {
        isConnectingState = NO;
        [self doSetupDevice:searchCallbackId];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"true"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
    }
    isDeviceConnected = YES;  
}

- (void)onDisconnected {
    NSLog(@"Disconnected");
    isDeviceConnected = NO;
    if (deviceDisconnectedCallbackId != nil){
        CDVPluginResult* pluginResult = nil; 
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"true"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:deviceDisconnectedCallbackId];
    }         
}

- (void)onError:(NSString *)message {
    NSLog(@"Error");
    NSLog(message);
    isDeviceConnected = NO;
    [self doSearchForDevice:searchCallbackId];
}

#pragma RUADelegate implementation

- (void)discoveredDevice:(RUADevice *)reader {
    bool isIncluded = false;
    for(RUADevice *device in deviceList){
        if([device.identifier isEqualToString:reader.identifier]){
            isIncluded = true;
            break;
        }
    }
    if(!isIncluded && reader.name!= NULL){
        NSArray *array = [reader.name componentsSeparatedByString:@"-"];
        NSString *deviceType = array[0];
        
        bool ok = false;
        
        if ([deviceType isEqualToString:@"G4x"]){
            [[Ingenico sharedInstance].PaymentDevice setDeviceType:RUADeviceTypeG4x]; 
            ok = true;                               
        } else if ([deviceType isEqualToString:@"RP45BT"]){
            [[Ingenico sharedInstance].PaymentDevice setDeviceType:RUADeviceTypeRP45BT]; 
            ok = true;                               
        } else if ([deviceType isEqualToString:@"RP350"]){
            [[Ingenico sharedInstance].PaymentDevice setDeviceType:RUADeviceTypeRP350x]; 
            ok = true;                       
        } else if ([deviceType isEqualToString:@"RP450"]){
            [[Ingenico sharedInstance].PaymentDevice setDeviceType:RUADeviceTypeRP450c]; 
            ok = true;                       
        } else if ([deviceType isEqualToString:@"RP750"]){
            [[Ingenico sharedInstance].PaymentDevice setDeviceType:RUADeviceTypeRP750x]; 
            ok = true;                       
        } else if ([deviceType isEqualToString:@"MOBY3000"]){
            [[Ingenico sharedInstance].PaymentDevice setDeviceType:RUADeviceTypeMOBY3000]; 
            ok = true;                       
        } else if ([deviceType isEqualToString:@"MOBY8500"]){
            [[Ingenico sharedInstance].PaymentDevice setDeviceType:RUADeviceTypeMOBY8500]; 
            ok = true;                       
        }

        if (ok) {
            [deviceList addObject:reader];
            NSLog(@"New device discovered");
        }        
    }
}

- (void)discoveryComplete {
    NSLog(@"Discovery Completed");
    CDVPluginResult* pluginResult = nil;

    if (isConnectingState == NO) {
        NSString *json = [deviceList JSONString];

        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:json];                           
        [self.commandDelegate sendPluginResult:pluginResult callbackId:searchCallbackId];
    } else {
        if ([deviceList count] > 0){
            NSLog(@"Selecting device");
            RUADevice *device = deviceList[0];
            [[Ingenico sharedInstance].PaymentDevice select:device];
            [[Ingenico sharedInstance].PaymentDevice initialize:self];
        } else {
            if (keepSearchingDevices == YES) {
                NSLog(@"Keep searching until a device is found");
                [self doSearchForDevice:searchCallbackId];
            } else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"false"];   
                [self.commandDelegate sendPluginResult:pluginResult callbackId:searchCallbackId];
            }
        }        
    }
}

- (void)selectDevice:(CDVInvokedUrlCommand*)command 
{
    callbackId = command.callbackId;
    NSString *deviceJSON = [command.arguments objectAtIndex:0]; 
    RUADevice *deviceIn = [RUADevice objectWithJSONString:deviceJSON];
    bool ok = false;
    for(RUADevice *device in deviceList){
        if([device.identifier isEqualToString:deviceIn.identifier]){
            [[Ingenico sharedInstance].PaymentDevice select:device];
            [[Ingenico sharedInstance].PaymentDevice initialize:self];

            ok = true;                                       
            break;
        }
    }

    CDVPluginResult* pluginResult = nil;
    if (ok != true) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"false"];   
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }  
}

- (void)setupDevice:(CDVInvokedUrlCommand*)command {
    [self doSetupDevice:command.callbackId];
}

- (void)doSetupDevice:(NSString *)callbackId {
    NSLog(@"doSetupDevice");
    [[[Ingenico sharedInstance] PaymentDevice] checkDeviceSetup:^(NSError *error,bool isSetupRequired) {
        if(error){
            CDVPluginResult* pluginResult = nil;
            NSString *responseCode = [NSString stringWithFormat:@"%i", error.code];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:responseCode];   
            [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
        } else {
            if(isSetupRequired){
                [[Ingenico sharedInstance].PaymentDevice setup:^(NSError *error) {
                    CDVPluginResult* pluginResult = nil;
                    if(error){
                        NSString *responseCode = [NSString stringWithFormat:@"%i", error.code];
                        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:responseCode];  
                    } else{
                        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"true"];                        
                    }
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
                }];
            } else {
                CDVPluginResult* pluginResult = nil;
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"true"];   
                [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
            }
        }
    }];
}

- (void)processCashTransaction:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;   
    @try {             
        NSString *amountJSON = [command.arguments objectAtIndex:0]; 
        NSString *productsJSON = [command.arguments objectAtIndex:1]; 
        //NSString *longitude = [command.arguments objectAtIndex:2]; 
        //NSString *latitude = [command.arguments objectAtIndex:3]; 
        //NSString *transactionGroupID = [command.arguments objectAtIndex:4];
        
        IMSAmount *amount = [IMSAmount objectWithJSONString:amountJSON];    

        IMSCashSaleTransactionRequest *request = [[IMSCashSaleTransactionRequest alloc] initWithAmount:amount
                                                    andProducts:nil
                                                    // andCustomerInfo:nil
                                                    andLongitude:nil //longitude
                                                    andLatitude:nil //latitude
                                                    andTransactionGroupID:nil //transactionGroupID
                                                ];                                                                                     
        
        [[Ingenico sharedInstance].Payment processCashTransaction:request andOnDone:^(IMSTransactionResponse *response, NSError *error)
        {
            CDVPluginResult* pluginResult = nil;   
            if(!error){
                NSString *JSONresponse = [response JSONString];
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:JSONresponse];   
            } else {      
                NSString *responseCode = [NSString stringWithFormat:@"%i", error.code];
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:responseCode];  
            }

            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
    }
    @catch ( NSException *e ) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:e.reason];   
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    } 
}

- (void)processCreditSaleTransactionWithCardReader:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;   
    @try {             
        NSString *amountJSON = [command.arguments objectAtIndex:0]; 
        NSString *productsJSON = [command.arguments objectAtIndex:1]; 
        NSString *longitude = [command.arguments objectAtIndex:2]; 
        NSString *latitude = [command.arguments objectAtIndex:3]; 
        NSString *transactionGroupID = [command.arguments objectAtIndex:4];
        
        IMSAmount *amount = [IMSAmount objectWithJSONString:amountJSON];

        IMSCreditSaleTransactionRequest *request = [[IMSCreditSaleTransactionRequest alloc] initWithAmount:amount
            andProducts:nil
            andClerkID:nil
            andLongitude:nil
            andLatitude:nil
            andTransactionGroupID:nil
            andTransactionNotes:nil
            andMerchantInvoiceID:nil
            andShowNotesAndInvoiceOnReceipt:true
            andTokenRequestParameters:nil
            andCustomReference:nil
            andIsCompleted:false
            andUCIFormat:UCIFormatIngenico];

        [[Ingenico sharedInstance].Payment processCreditSaleTransactionWithCardReader:request
            andUpdateProgress:^(IMSProgressMessage message, NSString *extraMessage) { }
            andSelectApplication:^(NSArray *applicationList, NSError *error, ApplicationSelectedResponse appReponse) {
                appReponse((RUAApplicationIdentifier *)[applicationList objectAtIndex:0]);
            }
            andOnDone:^(IMSTransactionResponse *response, NSError *error) {
                CDVPluginResult* pluginResult = nil;   
                if(!error){
                    NSString *JSONresponse = [response JSONString];
                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:JSONresponse];   
                } else {    
                    NSString *responseCode = [NSString stringWithFormat:@"%i", error.code];
                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:responseCode];  
                }

                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }];                                                                                                             
    }
    @catch ( NSException *e ) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:e.reason];   
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }  
}

- (void)processDebitSaleTransactionWithCardReader:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;   
    @try {             
        NSString *amountJSON = [command.arguments objectAtIndex:0]; 
        NSString *productsJSON = [command.arguments objectAtIndex:1]; 
        NSString *longitude = [command.arguments objectAtIndex:2]; 
        NSString *latitude = [command.arguments objectAtIndex:3]; 
        NSString *transactionGroupID = [command.arguments objectAtIndex:4];
        
        IMSAmount *amount = [IMSAmount objectWithJSONString:amountJSON];

        IMSDebitSaleTransactionRequest *request = [[IMSDebitSaleTransactionRequest alloc] initWithAmount:amount
            andProducts:nil
            andLongitude:nil
            andLatitude:nil
            andTransactionGroupID:nil];

        [[Ingenico sharedInstance].Payment processDebitSaleTransactionWithCardReader:request
            andUpdateProgress:^(IMSProgressMessage message, NSString *extraMessage) { }
            andSelectApplication:^(NSArray *applicationList, NSError *error, ApplicationSelectedResponse appReponse) {
                appReponse((RUAApplicationIdentifier *)[applicationList objectAtIndex:0]);
            }
            andOnDone:^(IMSTransactionResponse *response, NSError *error) {
                CDVPluginResult* pluginResult = nil;   
                if(!error){
                    NSString *JSONresponse = [response JSONString];
                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:JSONresponse];   
                } else {    
                    NSString *responseCode = [NSString stringWithFormat:@"%i", error.code];
                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:responseCode];  
                }

                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }];                                                                                                             
    }
    @catch ( NSException *e ) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:e.reason];   
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

- (void)getReferenceForTransactionWithPendingSignature:(CDVInvokedUrlCommand*)command {
    NSString *txnID = [[Ingenico sharedInstance].Payment getReferenceForTransactionWithPendingSignature];
    CDVPluginResult* pluginResult = nil;

    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:txnID];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)uploadSignature:(CDVInvokedUrlCommand*)command {
    NSString *transactionReference = [command.arguments objectAtIndex:0]; 
    NSString *signatureImage = [command.arguments objectAtIndex:1]; 
    

    NSLog(@"Transaction Reference");
    NSLog(transactionReference);
    NSLog(@"Signature Image");
    NSLog(signatureImage);

    [[Ingenico sharedInstance].User uploadSignatureForTransactionWithId:transactionReference
                                        andSignature:signatureImage
                                        andOnDone:^(NSError *error) {
        CDVPluginResult* pluginResult = nil;
        if(error){
            /*Send email receipt failed(code in the response will indicates
            the result)*/
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:error.localizedDescription];
        } else {
            /*Send email receipt succeeded*/
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"true"];               
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}
@end
