export class TransactionType {
    /*!
     * Default value.
     */
    static TransactionTypeUnknown :number = 0;
    /*!
     * Card sale transaction.
     */
    static TransactionTypeCreditSale :number = 1;
    /*!
     * Cash sale transaction.
     */
    static TransactionTypeCashSale :number = 2;
    /*!
     * Credit Refund transaction.
     */
    static TransactionTypeCreditRefund :number = 3;
    /*!
     * Cash Refund transaction.
     */
    static TransactionTypeCashRefund :number = 4;
    /*!
     * Credit Void transaction.
     */
    static TransactionTypeCreditSaleVoid :number = 5;
    /*!
     * Credit Auth transaction.
     */
    static TransactionTypeCreditAuth :number = 6;
    /*!
     * Credit Auth Void transaction.
     */
    static TransactionTypeCreditAuthVoid :number = 7;
    /*!
     * Credit Auth Complete transaction.
     */
    static TransactionTypeCreditAuthCompletion :number = 8;
    /*!
     * Credit Auth Complete Void transaction.
     */
    static TransactionTypeCreditAuthCompletionVoid :number = 9;
    /*!
     * Debit sale transaction.
     */
    static TransactionTypeDebitSale :number = 10;
    /*!
     * Debit void transaction.
     */
    static TransactionTypeDebitSaleVoid :number = 11;
    /*!
     * Debit refund transaction.
     */
    static TransactionTypeDebitRefund :number = 12;
    /*!
     * Credit Refund Void transaction.
     */
    static TransactionTypeCreditRefundVoid :number = 13;
    /*!
     * Debit Refund Void transaction.
     */
    static TransactionTypeDebitRefundVoid :number = 14;
    /*!
     * Credit Force Sale transaction.
     * Similar to CreditSale except that payment authorized through other mediums..
     */
    static TransactionTypeCreditForceSale :number = 15;
    /*!
     * Credit Force Sale Void transaction.
     */
    static TransactionTypeCreditForceSaleVoid :number = 16;
    /*!
     * Credit Balance Inquiry transaction.
     */
    static TransactionTypeCreditBalanceInquiry :number = 17;
    /*!
     * Requests for token enrollment.
     */
    static TransactionTypeTokenEnrollment :number = 18;
    /*!
     * Credit Sale Adjust transaction.
     */
    static TransactionTypeCreditSaleAdjust :number = 19;
    /*!
     * Credit Sale Adjust Void transaction.
     */
    static TransactionTypeCreditSaleAdjustVoid :number = 20;
    /*!
     * Credit Auth Adjust transaction.
     */
    static TransactionTypeCreditAuthAdjust :number = 21;
    /*!
     * Credit Auth Adjust Void transaction.
     */
    static TransactionTypeCreditAuthAdjustVoid :number = 22;
    /*!
     * Debit Balance Inquiry.
     */
    static TransactionTypeDebitBalanceInquiry :number = 23;

    /**
     * Returns the value to the response code by code number
     *
     * @param code The number of the code to check against
     */
    static getTypeByNumber(code: number) {
        let responseValue = 'CardTypeUnknown';
        for (let prop in this) {
            if (typeof this[prop] === 'number' && this[prop] === code) {
                responseValue = prop;
                break;
            }
        }
        return responseValue;
    }
}
