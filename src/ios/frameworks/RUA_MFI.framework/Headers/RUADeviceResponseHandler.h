/*
 //////////////////////////////////////////////////////////////////////////////
 //
 // Copyright (c) 2015 - 2018. All Rights Reserved, Ingenico Inc.
 //
 //////////////////////////////////////////////////////////////////////////////
 */

#import <Foundation/Foundation.h>
#import "RUAResponse.h"
#ifndef ROAMreaderUnifiedAPI_RUAResponseHandler_h
#define ROAMreaderUnifiedAPI_RUAResponseHandler_h

typedef NS_ENUM(NSInteger, RUAProgressMessage) {
	RUAProgressMessagePleaseInsertCard,
	RUAProgressMessagePleaseRemoveCard,
	RUAProgressMessageSwipeDetected,
	RUAProgressMessageWaitingforCardSwipe,
	RUAProgressMessageWaitingforDevice,
	RUAProgressMessageDecodingStarted,
	RUAProgressMessageCommandSent,
    RUAProgressMessageICCErrorSwipeCard,
    RUAProgressMessageSwipeErrorReswipe,
    RUAProgressMessageMagCardDataInsertCard,
    RUAProgressMessageCardInserted,
    RUAProgressMessageCardReadError,
	RUAProgressMessageUnknown,
    RUAProgressMessageApplicationSelectionStarted,
    RUAProgressMessageApplicationSelectionCompleted,
    RUAProgressMessageCardHolderPressedCancelKey,
	RUAProgressMessageContactlessTransactionRevertedToContact,
    RUAProgressMessageDeviceBusy,
    RUAProgressMessageFirstPinEntryPrompt,
    RUAProgressMessageErrorReadingContactlessCard,
    RUAProgressMessageLasttPinEntryPrompt,
    RUAProgressMessageMultipleContactlessCardsDetected,
    RUAProgressMessagePinEntryFailed,
    RUAProgressMessagePinEntryInProgress,
    RUAProgressMessagePinEntrySuccessful,
    RUAProgressMessageRetrytPinEntryPrompt,
    RUAProgressMessageSwipeErrorReswipeMagStripe,
	RUAProgressMessageUpdatingFirmware,
    RUAProgressMessageTapDetected,
    RUAProgressMessageContactlessCardStillInField,
    RUAProgressMessageFirstEnterNewPINPrompt,
    RUAProgressMessageValidateNewPINPrompt,
    RUAProgressMessageRetryEnterNewPINPrompt,
    RUAProgressMessagePINChangeFailed,
    RUAProgressMessagePINChangeEnded,
    RUAProgressMessagePleaseSeePhone,
//  C017 is a Fallback progress message informing the mobile app that contactless transaction has failled and the cardholder should insert or swipe his card
    RUAProgressMessageContactlessInterfaceFailedTryContact,
    RUAProgressMessagePresentCardAgain,
    RUAProgressMessageCardRemoved,
    RUAProgressMessageCardBlocked,
    RUAProgressMessageNotAuthorized,
    RUAProgressMessageCompleteCardRemove,
    RUAProgressMessageRemoveCard,
    RUAProgressMessageInsertOrSwipeCard,
    RUAProgressMessageTransactionVoid,
    RUAProgressMessageCardReadOkRemoveCard,
    RUAProgressMessageProcessingTransaction,
    RUAProgressMessageCardHolderBypassedPIN,
    RUAProgressMessageNotAccepted,
    RUAProgressMessageProcessingDoNotRemoveCard,
    RUAProgressMessageAuthorizing,
    RUAProgressMessageNotAcceptedRemoveCard,
    RUAProgressMessageCardError,
    RUAProgressMessageCardErrorRemoveCard,
    RUAProgressMessageCancelled,
    RUAProgressMessageCancelledRemoveCard,
    RUAProgressMessageTransactionVoidRemoveCard,
    RUAProgressMessageUnknownAID,
	RUAProgressMessageReinsertCard,
};



typedef void (^OnProgress)(RUAProgressMessage messageType, NSString* additionalMessage);
typedef void (^OnResponse)(RUAResponse *response);

#endif
