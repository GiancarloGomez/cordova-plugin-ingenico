export class Product {
    name: string;
    price: number;
    note: string;
    base64EncodedProductImage: string;
    quantity: number;

    constructor(
        _name: string,
        _price: number,
        _note: string,
        _base64EncodedProductImage: string,
        _quantity: number
    ){
        this.name  = _name;
        this.price = _price;
        this.note  = _note;
        this.base64EncodedProductImage = _base64EncodedProductImage;
        this.quantity = _quantity;
    }
}