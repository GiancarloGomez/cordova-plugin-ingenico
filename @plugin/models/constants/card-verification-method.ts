export class CardVerificationMethod {
    /*!
     Default value.
     */
    static CardVerificationMethodNone :number = 0;

    /*!
     Requires PIN entry for verification.
     */
    static CardVerificationMethodPin :number = 1;

    /*!
     Requires cardholder signature for verification.
     */
    static CardVerificationMethodSignature :number = 2;

    /*!
     Requires both PIN and signature for verification.
     */
    static CardVerificationMethodPinAndSignature :number = 3;

    /**
     * Returns the value to the response code by code number
     *
     * @param code The number of the code to check against
     */
    static getVerificationMethodByNumber(code: number) {
        let responseValue = 'CardVerificationMethodNone';
        for (let prop in this) {
            if (typeof this[prop] === 'number' && this[prop] === code) {
                responseValue = prop;
                break;
            }
        }
        return responseValue;
    }
}
