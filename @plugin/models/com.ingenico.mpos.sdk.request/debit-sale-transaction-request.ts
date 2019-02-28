import { Amount } from "../com.ingenico.mpos.sdk.data/amount";
import { Product } from "../com.ingenico.mpos.sdk.data/product";

export class DebitSaleTransactionRequest {
    amount: Amount;
    products: Product[];
    transactionGroupID?: any;
    completed?: any;
    clerkID?: any;
    clientTransactionId: string;
    createdTime: string;
    customData?: any;
    customReference?: any;
    gpsLatitude: string;
    gpsLongitude: string;
    merchantInvoiceId?: any;
    showNotesAndInvoiceOnReceipt?: any;
    transactionNotes?: any;
    type: string;

    constructor(_amount: Amount, _products: Product[], _gpsLongitude: string, _gpsLatitude: string, _transactionGroupID?: any){
        this.amount = _amount;
        this.products = _products;
        this.gpsLongitude = _gpsLongitude;
        this.gpsLatitude = _gpsLatitude;
        this.transactionGroupID = _transactionGroupID;
    }
}