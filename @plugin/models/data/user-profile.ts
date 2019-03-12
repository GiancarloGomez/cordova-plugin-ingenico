import { Configuration } from "./configuration";
import { Processor } from "./processor";
import { Session } from "./session";
import { UserInfo } from "./user-info";

export class UserProfile {
    chainID: string;
    configuration: Configuration;
    processor: Processor;
    session: Session;
    storeID: string;
    terminalID: string;
    userInfo: UserInfo;
    version: string;
}