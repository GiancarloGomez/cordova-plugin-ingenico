export class POSEntryMode {
    /*!
     * Default value.
     */
    static POSEntryModeUnKnown: number = 0;
    /*!
     * Card not present.
     * Card data is captured through manually entering card information (PAN, Exp Date, CVV, AVS).
     */
    static POSEntryModeKeyed: number = 1;
    /*!
     * Card data is captured through ICC card insertion.
     */
    static POSEntryModeContactEMV: number = 2;
    /*!
     * EMV Card data is captured through NFC (Contactless cards, ApplePay, AndroidPay, etc.,).
     */
    static POSEntryModeContactlessEMV: number = 3;
    /*!
     * Magnetic Card data is captured through NFC (Contactless cards, ApplePay, AndroidPay, etc.,).
     */
    static POSEntryModeContactlessMSR: number = 4;
    /*!
     * Card data is captured through magnetic card swipe.
     */
    static POSEntryModeMagStripe: number = 5;
    /*!
     * Card data is captured through magnetic card swipe as a fall back mechanism when EMV transaction fails.
     */
    static POSEntryModeMagStripeEMVFail: number = 6;
    /*!
     * Card data is captured through Virtual terminal on Merchant portal (myRoam aka ROAMmerchant)
     */
    static POSEntryModeVirtualTerminal: number = 7;
    /*!
     * Token generated by capturing card data is used to perform the transaction
     */
    static POSEntryModeToken: number = 8;
    /*!
     * Card present. Fallback to keyed entry.
     * Card data is captured through manually entering card information (PAN, Exp Date, CVV, AVS).
     */
    static POSEntryModeKeyedSwipeFail: number = 9;

    /**
     * Returns the value to the pos entry mode by code number
     *
     * @param code The number of the code to check against
     */
    static getModeByNumber(code: number) {
        let mode = 'POSEntryModeUnKnown';
        for (let prop in this) {
            if (typeof this[prop] === 'number' && this[prop] === code) {
                mode = prop;
                break;
            }
        }
        return mode;
    }
}