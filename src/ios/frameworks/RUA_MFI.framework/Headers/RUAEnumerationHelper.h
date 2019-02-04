/*
 //////////////////////////////////////////////////////////////////////////////
 //
 // Copyright (c) 2015 - 2018. All Rights Reserved, Ingenico Inc.
 //
 //////////////////////////////////////////////////////////////////////////////
 */

#import <Foundation/Foundation.h>
#import "RUATransactionManager.h"
#import "RUADevice.h"
#import "RUAParameter.h"
#import "RUACommand.h"
#import "RUADeviceManager.h"
#import "RUAResponse.h"
#import "RUASystemLanguageHelper.h"

@interface RUAEnumerationHelper : NSObject

/**
 Converts string to enum
 @param strVal String value of the Card Type
 @return RUACardType enumeration
 */
+ (RUACardType)RUACardType_toEnumeration:(NSString *)strVal;

/**
 Converts enum to string
 @param cardType RUACardType enumeration
 @return String value of the Card Type
 */
+ (NSString *)RUACardType_toString:(RUACardType)cardType;

/**
 Converts string to enum
 @param strVal String value of the command
 @return RUACommand enumeration
 */
+ (RUACommand)RUACommand_toEnumeration:(NSString *)strVal;

/**
 Converts enum to string
 @param command RUACommand enumeration
 @return String value of the command
 */
+ (NSString *)RUACommand_toString:(RUACommand)command;

/**
 Converts string to enum
 @param strVal String value of the device type
 @return RUADeviceType enumeration
 */
+ (RUADeviceType)RUAReaderType_toEnumeration:(NSString *)strVal;

/**
 Converts enum to string
 @param language RUASystemLanguage enum
 @return String value of the language
 */
+ (NSString *)RUASystemLanguage_toString:(RUASystemLanguage)language;

/**
 Converts string to enum
 @param String value of the language
 @return language RUASystemLanguage enum
 */
+ (RUASystemLanguage)RUASystemLanguage_toEnumeration:(NSString *)strVal;
    
/**
 Converts enum to string
 @param readerType RUADeviceType enumeration
 @return String value of the device type
 */
+ (NSString *)RUADeviceType_toString:(RUADeviceType)readerType;

/**
 Converts string to enum
 @param strVal String value of the communication interface type
 @return RUACommunicationInterface enumeration
 @see RUACommunicationInterface
 */
+ (RUACommunicationInterface)RUACommunicationInterface_toEnumeration:(NSString *)strVal;

/**
 Converts enum to string
 @param interface RUACommunicationInterface enumeration
 @return String value of the communication interface type
 @see RUACommunicationInterface
 */
+ (NSString *)RUACommunicationInterface_toString:(RUACommunicationInterface)interface;

/**
 Converts string to enum
 @param strVal String value of the response code
 @return RUAResponseCode enumeration
 @see RUAResponseCode
 */
+ (RUAResponseCode)RUAResponseCode_toEnumeration:(NSString *)strVal;

/**
 Converts enum to string
 @param code RUAResponseCode enumeration
 @return String value of the response code
 @see RUAResponseCode
 */
+ (NSString *)RUAResponseCode_toString:(RUAResponseCode)code;

/**
 Converts string to enum
 @param strVal String value of the error code
 @return RUAErrorCode enumeration
 @see RUAErrorCode
 */
+ (RUAErrorCode)RUAErrorCode_toEnumeration:(NSString *)strVal;

/**
 Converts enum to string
 @param code RUAErrorCode enumeration
 @return String value of the error code
 @see RUAErrorCode
 */
+ (NSString *)RUAErrorCode_toString:(RUAErrorCode)code;

/**
 Converts string to enum
 @param strVal String value of the parameter
 @return RUAParameter parameter
 @see RUAParameter
 */
+ (RUAParameter)RUAParameter_toEnumeration:(NSString *)strVal;

/**
 Converts enum to string
 @param code RUAParameter enumeration
 @return String value of the parameter
 @see RUAParameter
 */
+ (NSString *)RUAParameter_toString:(RUAParameter)code;

/**
 Converts string to enum
 @param strVal String value of the parameter
 @return RUAResponseType parameter
 @see RUAResponseType
 */
+ (RUAResponseType)RUAResponseType_toEnumeration:(NSString *)strVal;

/**
 Converts enum to string
 @param code RUAResponseType enumeration
 @return String value of the parameter
 @see RUAResponseType
 */
+ (NSString *)RUAResponseType_toString:(RUAResponseType)code;


/**
 Converts enum to string
 @param message RUAProgressMessage enumeration
 @return String value of the parameter
 @see RUAProgressMessage
 */
+ (NSString *)RUAProgressMessage_toString:(RUAProgressMessage)message;

@end
