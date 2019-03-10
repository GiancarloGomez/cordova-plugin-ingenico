import { AccountFlags } from "./account-flags";

export class UserInfo {
    accountFlags: AccountFlags;
    cellPhone: string;
    firstName: string;
    lastName: string;
    locale: string;
    middleNameInitial?: any;
    otherPhone?: any;
    primaryEmail: string;
    securityQuestions: any[];
    title?: any;
    workPhone: string;
}