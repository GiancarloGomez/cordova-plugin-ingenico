export class Amount {
    currency: string;
    discount: number;
    discountDescription: string;
    subtotal: number;
    surcharge?: any;
    tax: number;
    tip: number;
    total: number;

    constructor(_currency: string, _total: number, _subtotal: number, _tax: number, _discount: number, _discountDescription: string, _tip: number){
        this.currency = _currency;
        this.total = _total;
        this.subtotal = _subtotal;
        this.tax = _tax;
        this.discount = _discount;
        this.discountDescription = _discountDescription;
        this.tip = _tip;
     }
}