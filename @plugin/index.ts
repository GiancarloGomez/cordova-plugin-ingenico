import { Injectable } from "@angular/core";
import { Plugin, Cordova } from "@ionic-native/core";
import {
    CashSaleTransactionRequest,
    CreditSaleTransactionRequest,
    DebitSaleTransactionRequest,
    Device,
    TransactionResponse,
    UserProfile
} from "./models";

@Plugin({
    pluginName : "Ingenico",
    plugin     : "cordova-plugin-ingenico",
    pluginRef  : "Ingenico",
    platforms  : ["iOS"]
})


@Injectable()
export class Ingenico {

    /*************************************
     * Authentication
    **************************************/

    @Cordova()
    initialize(apiKey: string, baseUrl: string, clientVersion: string): Promise<boolean> {
        return;
    }

    @Cordova()
    login(username: string, password: string): Promise<UserProfile>{
        return;
    }

    @Cordova()
    logoff(): Promise<boolean>{
        return;
    }

    @Cordova()
    refreshUserSession(): Promise<UserProfile>{
        return;
    }

    @Cordova()
    isInitialized(): Promise<boolean> {
        return;
    }

    @Cordova()
    isLoggedIn(): Promise<boolean>{
        return;
    }

    /*************************************
     * Device Information
    **************************************/

    @Cordova()
    getBatteryLevel(): Promise<number>{
        return;
    }

    @Cordova()
    getDeviceType(): Promise<number>{
        return;
    }

    @Cordova()
    getDeviceSerialNumber(): Promise<string> {
        return;
    }

    /*************************************
     * Device Connection and Setup
    **************************************/

    @Cordova()
    connect(): Promise<boolean>{
        return;
    }

    @Cordova()
    disconnect(): Promise<boolean>{
        return;
    }

    @Cordova()
    isDeviceConnected(): Promise<boolean>{
        return ;
    }

    @Cordova()
    selectDevice(device: Device): Promise<boolean> {
        return;
    }

    @Cordova()
    setDeviceType(deviceType: any): Promise<boolean>{
        return;
    }

    @Cordova()
    setupDevice(): Promise<boolean> {
        return;
    }

    @Cordova()
    configureIdleShutdownTimeout(timeoutInSeconds: Number): Promise<boolean> {
        return;
    }

    /*************************************
     * Device Search
    **************************************/

    @Cordova()
    searchForDevice(): Promise<Device[]>{
        return;
    }

    @Cordova()
    stopSearchForDevice(): Promise<boolean>{
        return;
    }

    /*************************************
     * Transactions
     **************************************/

    @Cordova()
    processCashTransaction(cashTransaction: CashSaleTransactionRequest): Promise<TransactionResponse>{
        return;
    }

    @Cordova()
    processCreditSaleTransactionWithCardReader(creditSaleTransaction: CreditSaleTransactionRequest): Promise<TransactionResponse>{
        return;
    }

    @Cordova()
    processDebitSaleTransactionWithCardReader(debitSaleTransaction: DebitSaleTransactionRequest): Promise<TransactionResponse>{
        return;
    }

    @Cordova()
    processVoidTransaction(originalSaleTransactionID: string): Promise<TransactionResponse>{
        return;
    }
}