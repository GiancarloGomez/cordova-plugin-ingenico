import { Currency } from "./currency";

export class Configuration {
    captureInvoiceNumberConfig: string;
    capturePurchaseNotesConfig: string;
    currency: Currency;
    defaultTax: number;
    latestAppVersion?: any;
    sessionTimeoutInMins: number;
    signatureCaptureConfig: string;
    smallTicketConfig: string;
    smallTicketContactlessConfig: string;
    smallTicketContactlessThreshold: number;
    smallTicketThreshold: number;
    taxConfig: string;
    tenderTypes: string[];
    avsVerificationEnabled: boolean;
    collectGeoLocationEnabled: boolean;
    collectOptionalInformationEnabled: boolean;
    cvvVerificationEnabled: boolean;
    discountEnabled: boolean;
    editEmailReceiptEnabled: boolean;
    inventoryManagementEnabled: boolean;
    manualEntryEnabled: boolean;
    mobileRefundEnabled: boolean;
    pinpadManualEntryEnabled: boolean;
    refundEnabled: boolean;
    signatureCaptureVisible: boolean;
    smallTicketContactlessVisible: boolean;
    smallTicketVisibile: boolean;
    smartRefundEnabled: boolean;
    taxVisible: boolean;
    tipEnabled: boolean;
    voidEnabled: boolean;
}