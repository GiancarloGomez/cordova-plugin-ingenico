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

  @Cordova()
  login(username: string, password: string, apiKey: string, baseUrl: string, clientVersion: string): Promise<UserProfile>{
    return;
  }

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
  onDeviceDisconnected(): Promise<boolean>{
    return ;
  }

  @Cordova()
  setDeviceType(deviceType: any): Promise<boolean>{
    return;
  }

  @Cordova()
  searchForDevice(): Promise<Device[]>{
    return;
  }

  @Cordova()
  stopSearchForDevice(): Promise<boolean>{
    return;
  }

  @Cordova()
  selectDevice(device: Device): Promise<boolean>{
    return;
  }

  @Cordova()
  setupDevice(): Promise<boolean>{
    return;
  }

  @Cordova()
  processCashTransaction(cashTransaction: CashSaleTransactionRequest): Promise<TransactionResponse> {
    return;
  }

  @Cordova()
  processCreditSaleTransactionWithCardReader(creditSaleTransaction: CreditSaleTransactionRequest): Promise<TransactionResponse> {
    return;
  }

  @Cordova()
  processDebitSaleTransactionWithCardReader(debitSaleTransaction: DebitSaleTransactionRequest): Promise<TransactionResponse> {
    return;
  }

  @Cordova()
  getReferenceForTransactionWithPendingSignature(): Promise<string> {
    return;
  }

  @Cordova()
  uploadSignature(transactionReference: string, signatureImage: string): Promise<boolean> {
    return;
  }
}