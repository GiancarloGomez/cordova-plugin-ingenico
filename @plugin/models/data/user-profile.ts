import { Configuration } from "./configuration";
import { Processor } from "./processor";
import { Session } from "./session";
import { UserInfo } from "./user-info";

export class UserProfile {
    chainId: string;
    configuration: Configuration;
    processor: Processor;
    session: Session;
    storeId: string;
    terminalId: string;
    userInfo: UserInfo;
}