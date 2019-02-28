import { EmvData } from "../com.ingenico.mpos.sdk.data/emv-data";
import { TokenResponseParameters } from "../com.ingenico.mpos.sdk.data/token-response-parameters";
import { Amount } from "../com.ingenico.mpos.sdk.data/amount";

export class TransactionResponse {
    emvData: EmvData;
    availableBalance: number;
    uniqueCardIdentifier?: any;
    tokenResponseParameters: TokenResponseParameters;
    transactionGUID: string;
    submittedAmount: Amount;
    authCode?: any;
    cardExpirationDate?: any;
    transactionGroupID: string;
    invoiceID: string;
    transactionResponseCode: number;
    sequenceNumber: string;
    authorizedAmount: number;
    cardType: number;
    posEntryMode: number;
    avsResponse: number;
    cardVerificationMethod: number;
    uciFormat: number;
    clientTransactionID: string;
    transactionID: string;
    clerkDisplay?: any;
    redactedCardNumber?: any;
}