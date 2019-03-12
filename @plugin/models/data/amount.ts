export class Amount {
    total: number;
    subTotal: number;
    tax: number;
    discount: number;
    discountDescription: string;
    tip: number;
    currency: string;
    surcharge: number;

    constructor(
        _total: number,
        _subtotal: number,
        _tax: number,
        _discount: number,
        _discountDescription: string,
        _tip: number,
        _currency: string,
        _surcharge: number
    ){
        this.total = _total;
        this.subTotal = _subtotal;
        this.tax = _tax;
        this.discount = _discount;
        this.discountDescription = _discountDescription;
        this.tip = _tip;
        this.currency = _currency;
        this.surcharge = _surcharge;
     }
}