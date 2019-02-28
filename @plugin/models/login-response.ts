import { UserProfile } from "./com.ingenico.mpos.sdk.data/user-profile";

export class LoginResponse {
    responseCode: number;
    user: UserProfile;
}