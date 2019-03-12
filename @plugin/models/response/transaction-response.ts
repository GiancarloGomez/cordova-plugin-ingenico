import { EmvData } from "../data/emv-data";
import { TokenResponseParameters } from "../data/token-response-parameters";
import { Amount } from "../data/amount";

export class TransactionResponse {
    authorizedAmount: number;
    authCode?: any;
    transactionID: string;
    invoiceID: string;
    transactionGroupID: string;
    clerkDisplay?: any;
    clientTransactionID: string;
    sequenceNumber: string;
    cardVerificationMethod: number;
    posEntryMode: number;
    redactedCardNumber?: any;
    cardExpirationDate?: any;
    availableBalance: number;
    submittedAmount: Amount;
    tokenResponseParameters: TokenResponseParameters;
    transactionGUID: string;
    transactionResponseCode: any;
    cardType: any;
    emvData: EmvData;
    avsResponse: any;
    uciFormat: any;
    uniqueCardIdentifier?: any;
    cardholderName?: string;
    batchNumber?: string;
    transactionType?: any;
}