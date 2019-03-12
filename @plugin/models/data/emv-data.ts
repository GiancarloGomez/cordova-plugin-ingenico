import { EmvOfflineData } from "./emv-offline-data";

export class EmvData {
    appIdentifier?: any;
    appPreferredName?: any;
    appLabel?: any;
    cryptogramType?: any;
    pinStatement?: any;
    emvOfflineData: EmvOfflineData;
}