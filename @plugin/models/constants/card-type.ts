export class CardType {
    /*!
     * Default value.
     */
    static CardTypeUnknown :number = 0;
    /*!
     * American Express.
     */
    static CardTypeAMEX :number = 1;
    /*!
     * Discover.
     */
    static CardTypeDiscover :number = 2;
    /*!
     * MasterCard.
     */
    static CardTypeMasterCard :number = 3;
    /*!
     * VISA.
     */
    static CardTypeVISA :number = 4;
    /*!
     * JCB.
     */
    static CardTypeJCB :number = 5;
    /*!
     * Diners.
     */
    static CardTypeDiners :number = 6;
    /*!
     * Maestro.
     */
    static CardTypeMaestro :number = 7;

    /**
     * Returns the value to the response code by code number
     *
     * @param code The number of the code to check against
     */
    static getCardTypeByNumber(code: number) {
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
