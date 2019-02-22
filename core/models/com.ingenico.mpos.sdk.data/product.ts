export class Product {
    subtotal: number;
    image: string;
    name: string;
    description: string;
    note: string;
    price: number;
    quantity: number;

    constructor(_name: string, _subtotal: number, _description: string, _image: string, _quantity: number){
        this.name = _name;
        this.subtotal = _subtotal;
        this.description = _description;
        this.image = _image;
        this.quantity = _quantity;
    }
}