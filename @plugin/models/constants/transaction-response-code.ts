export class TransactionResponseCode {
    /*!
     * Default Value.
     */
    static TransactionResponseCodeUnKnown:number = 0;
    /*!
     * Transaction approved.
     */
    static TransactionResponseCodeApproved:number = 1;
    /*!
     * Transaction declined.
     */
    static TransactionResponseCodeDeclined:number = 2;
    /*!
     * Transaction is referral.
     */
    static TransactionResponseCodeReferral:number = 3;
    /*!
     * Verify error.
     */
    static TransactionResponseCodeVerifyError:number = 4;
    /*!
     * Pass phrase expired.
     */
    static TransactionResponseCodePassPhraseExpired:number = 5;
    /*!
     * Invalid pass phrase.
     */
    static TransactionResponseCodeInvalidPassPhrase:number = 6;
    /*!
     * Binary data response.
     */
    static TransactionResponseCodeBinaryDataResponse: number = 7;

    /**
     * Returns the value to the response code by code number
     *
     * @param code The number of the code to check against
     */
    static getResponseByNumber(code: number) {
        let responseValue = 'TransactionResponseCodeUnKnown';
        for (let prop in this) {
            if (typeof this[prop] === 'number' && this[prop] === code) {
                responseValue = prop;
                break;
            }
        }
        return responseValue;
    }
}
