/*
 //////////////////////////////////////////////////////////////////////////////
 //
 // Copyright (c) 2015 - 2018. All Rights Reserved, Ingenico Inc.
 //
 //////////////////////////////////////////////////////////////////////////////
 */

#import <Foundation/Foundation.h>

typedef enum {
	RUALanguageCodeENGLISH = 0,
	RUALanguageCodeFRENCH = 1
}RUALanguageCode;

typedef enum{
    /** All data requested (swiped or keyed) */
    RUAKeyedDataAllDataSwipeOrKeyed,
    
    /** All data requested except cvv (swiped or keyed)*/
    RUAKeyedDataExceptCVVSwipeOrKeyed,
    
    /** All data requested except cvv (swiped or keyed or chip)*/
    RUAKeyedDataExceptCVVChipOrSwipeOrKeyed,
    
    /** Request only CVV; Must immediately follow KeyedData = ExceptCVVSwipeOrKeyed or
     KeyedData = ExceptCVVChipOrSwipeOrKeyed command*/
    RUAKeyedDataOnlyCVV,
    
    /** Request only CVV with 4 digits allowed; Must immediately follow KeyedData = ExceptCVVSwipeOrKeyed or
     KeyedData = ExceptCVVChipOrSwipeOrKeyed command*/
    RUAKeyedDataOnlyCVVFourDigitsAllowed,
    
    /** All data requested (keyed only) */
    RUAKeyedDataAllDataKeyedOnly,
    
    /** All data requested except cvv (keyed only)*/
    RUAKeyedDataExceptCVVKeyedOnly,
    
    RUAKeyedDataUnknown
}RUAKeyedData;

/**
 * KeyPadControl provides interface to control the keypad of ROAM device.<br>
 * @author rkondaveti
 */
@protocol RUAKeypadControl <NSObject>
/**
 * This methods sends the command to keypad to set click duration and click frequency. <br>
 * @param clickDuration                 Click duration
 * @param clickFrequnecy                Click frequency
 * @param response                      OnResponse block
 */
- (void)setClickFrequency:(int)clickDuration frequency:(int)clickFrequnecy response:(OnResponse)response;

/**
 * This methods sends the command to keypad to prompt for PIN with TDES DUKPT ISO PIN Block encryption. <br>
 * When the reader processes the command, it returns the result as a map to
 * the callback method onResponse on the DeviceResponseHandler passed.<br>
 * The map passed to the onResponse callback contains the following
 * parameters as keys, <br>
 * - Parameter.ResponseCode (ResponseCode enumeration as value)<br>
 * - Parameter.ErrorCode (if not successful, ErrorCode enumeration as value)<br>
 * - Parameter.EncryptedIsoPinBlock<br>
 * - Parameter.KSN<br>
 * @param languageCode                  Language code
 * @param pinBlockFormat                Pin block format
 * @param keyLocator                    Key locator
 * @param cardLast4Digits               Last four digits of the card
 * @param macData                       Mac data
 * @param clearOnlyLastDigitEntered     BOOL describes, if only the last digit entered is cleared
 * @param interDigitTimeout             Inter digit timeout
 * @param response                      OnResponse block
 */
- (void)promptPinTDESBlockWithEncryptedPAN:(RUALanguageCode)languageCode pinBlockFormat:(NSString *)pinBlockFormat keyLocator:(NSString *)keyLocator
                           cardLast4Digits:(NSString *)cardLast4Digits macData:(NSString *)macData clearOnlyLastDigitEntered:(BOOL)clearOnlyLastDigitEntered
                         interDigitTimeout:(int)interDigitTimeout response:(OnResponse)response;

/**
 * This methods sends the command to keypad to prompt for PIN with Master and session key encryption. <br>
 * When the reader processes the command, it returns the result as a map to
 * the callback method onResponse on the DeviceResponseHandler passed.<br>
 * The map passed to the onResponse callback contains the following
 * parameters as keys, <br>
 * - Parameter.ResponseCode (ResponseCode enumeration as value)<br>
 * - Parameter.ErrorCode (if not successful, ErrorCode enumeration as value)<br>
 * - Parameter.EncryptedIsoPinBlock<br>
 * - Parameter.KSN<br>
 * @param languageCode                  Language code
 * @param pinBlockFormat                Pin block format
 * @param keyLocator                    Key locator
 * @param cardLast4Digits               Last four digits of the card
 * @param clearOnlyLastDigitEntered     BOOL describes, if only the last digit entered is cleared
 * @param interDigitTimeout             Inter digit timeout
 * @param response                      OnResponse block
 */
- (void)promptPinMasterSessionKeyWithEncryptedPAN:(RUALanguageCode)languageCode pinBlockFormat:(NSString *)pinBlockFormat keyLocator:(NSString *)keyLocator
                                  cardLast4Digits:(NSString *)cardLast4Digits clearOnlyLastDigitEntered:(BOOL)clearOnlyLastDigitEntered
                                interDigitTimeout:(int)interDigitTimeout response:(OnResponse)response;


/**
 This method sends the command to keypad to collect card data (PAN, expiry date, CVC)
 from the user.<br>
 When the reader processes the command, it returns the result as a map to  the OnResponse block passed.<br>
 The map passed to the onResponse callback contains the following parameters as keys, <br>
 @param response OnResponse block
 @param progress OnProgress block
 */

- (void)retrieveKeyedCardData:(OnProgress)progress response:(OnResponse)response;

/**
 This method sends the command to keypad to collect card data (PAN, expiry date, CVC)
 from the user.<br>
 When the reader processes the command, it returns the result as a map to  the OnResponse block passed.<br>
 The map passed to the onResponse callback contains the following parameters as keys, <br>
 @param keyedData the type of data requested
 @param response OnResponse block
 @param progress OnProgress block
 
 @see KeyedData
 
 */

- (void)retrieveKeyedCardData:(RUAKeyedData)keyedData progress:(OnProgress)progress response:(OnResponse)response;

/**
 This method is used to collect the zipcode from the customer
 @param response OnResponse block
 @param progress OnProgress block
 */
- (void)retrieveZipCode:(OnProgress)progress response:(OnResponse)response;

/**
 This method is used to collect the tip amount from the customer
 @param response OnResponse block
 @param progress OnProgress block
 */
- (void)retrieveTipAmount:(OnProgress)progress response:(OnResponse)response;



@end
