/*
 //////////////////////////////////////////////////////////////////////////////
 //
 // Copyright (c) 2015 - 2018. All Rights Reserved, Ingenico Inc.
 //
 //////////////////////////////////////////////////////////////////////////////
 */

#import <Foundation/Foundation.h>

typedef enum {
    
	/** 0: EMVL1 Ingenico Proprietary character defined in Appendix A Section 11.1. */
	RUADisplayTextCharsetEMVL1,
	/** 1: EMVL2 Character Set (ISO 8859_1 + Euro Symbol) defined in Appendix A Section 11.2 */
	RUADisplayTextCharsetEMVL2
} RUADisplayTextCharset;

/**
 * DisplayControl provides interface to control the display of ROAM device.<br>
 */
@protocol RUADisplayControl <NSObject>
/**
 * This method turns on the LCD of the back light PIN Pad
 *
 * @param enable                true to turn on the back light
 * @param response              OnResponse block
 */
- (void)enableBackLight:(BOOL)enable response:(OnResponse)response;

/**
 * This method clears the text that is being displayed on the screen
 *
 * @param response              OnResponse block
 */
- (void)clearDisplay:(OnResponse)response;


/**
 * This method starts the screen saver if the device supports
 *
 * @param response              OnResponse block
 */
- (void)startScreensaver:(OnResponse)response;

/**
 * This method stop the screen saver if the device supports
 *
 * @param response              OnResponse block
 */
- (void)stopScreensaver:(OnResponse)response;

/**
 * This method sets the display of the LCD on the PIN pad device
 *
 * @param mode                  ‘00’ for 4 lines, 16 columns. ‘01' for 8 lines, 16 columns.
 *                              ‘02’ for 8 lines, 21 columns.
 * @param response              OnResponse block
 */
- (void)setDisplayMode:(NSString *)mode response:(OnResponse)response;


/**
 * This method sets the back light control on the PIN pad device
 *
 * @param enableOnStartup       Enable on startup
 * @param backlightBrightness   Backlight brightness
 * @param response              OnResponse block
 */
- (void)setBackLightControl:(BOOL)enableOnStartup brightness:(Byte)backlightBrightness response:(OnResponse)response;

/**
 * This method writes the text to the LCD at the specified row and column,
 *
 * @param row                   Row number
 * @param column                Column number
 * @param charset               RUADisplayTextCharset.EMVL1 or DisplayTextCharset.EMVL2
 * @param text                  Textstring
 * @param response              OnResponse block
 */
- (void)writeText:(int)row column:(int)column charset:(RUADisplayTextCharset)charset test:(NSString *)text response:(OnResponse)response;

/**
 * This method returns the device to the home screen.
 *
 * @param response              OnResponse block
 */
- (void)returnToHomeScreen:(OnResponse)response;


@end
