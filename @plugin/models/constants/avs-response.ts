export class AVSResponse {
    /*!
     * Unable to determine AVS response
     */
    static AVSResponseUnknown :number = 0;
    /*!
     * Address and 9 digit zip match (MC)
     */
    static AVSResponseX :number = 1;
    /*!
     * Address and 5 digit zip match (Visa, MC, Amex, Disc)
     */
    static AVSResponseY :number = 2;
    /*!
     * Address match, zip did not (Visa, MC, Amex, Disc)
     */
    static AVSResponseA :number = 3;
    /*!
     * 9 digit Zip match, address did not (MC, Disc)
     */
    static AVSResponseW :number = 4;
    /*!
     * 5 digit Zip match, address did not (Visa, MC, Amex, Disc)
     */
    static AVSResponseZ :number = 5;
    /*!
     * No match (Visa, MC, Amex, Disc)
     */
    static AVSResponseN :number = 6;
    /*!
     * System unavailable (Visa, MC, Amex, Disc)
     */
    static AVSResponseU :number = 7;
    /*!
     * Issuer timeout, retry (Visa, MC, Amex)
     */
    static AVSResponseR :number = 8;
    /*!
     * Data invalid (Visa)
     */
    static AVSResponseE :number = 9;
    /*!
     * Bank does not support AVS (Visa, MC, Amex)
     */
    static AVSResponseS :number = 10;
    /*!
     * Address and Zip match, international
     */
    static AVSResponseD :number = 11;
    /*!
     * Address and Zip match, international
     */
    static AVSResponseM :number = 12;
    /*!
     * Address match, zip not verified, international
     */
    static AVSResponseB :number = 13;
    /*!
     * Zip match, address not verified, international
     */
    static AVSResponseP :number = 14;
    /*!
     * No match, international
     */
    static AVSResponseC :number = 15;
    /*!
     * Not verified, international
     */
    static AVSResponseI :number = 16;
    /*!
     * Not supported, international
     */
    static AVSResponseG :number = 1;

    /**
     * Returns the value to the response code by code number
     *
     * @param code The number of the code to check against
     */
    static getResponseByNumber(code: number) {
        let responseValue = 'AVSResponseUnknown';
        for (let prop in this) {
            if (typeof this[prop] === 'number' && this[prop] === code) {
                responseValue = prop;
                break;
            }
        }
        return responseValue;
    }
}
