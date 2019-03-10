import { UserProfile } from "../data/user-profile";

export class LoginResponse {
    responseCode: number;
    user: UserProfile;
}