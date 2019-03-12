export class DeviceType {
    static G4x: string      = "RUADeviceTypeG4x";
    static RP45BT: string   = "RUADeviceTypeRP45BT";
    static RP350x: string   = "RUADeviceTypeRP350x";
    static RP450c: string   = "RUADeviceTypeRP450c";
    static RP750x: string   = "RUADeviceTypeRP750x";
    static MOBY3000: string = "RUADeviceTypeMOBY3000";
    static MOBY8500: string = "RUADeviceTypeMOBY8500";
    static Unknown: string  = "RUADeviceTypeUnknown";

    /**
     * Returns the string version of the device
     *
     * @param position The position used to fetch the device as returned by SDK
     */
    static getTypeByPosition(position: number) {
        let pos: number = 0,
            dtype = this.Unknown;
        for (let type in this) {
            if (typeof this[type] === 'string') {
                if (pos === position) {
                    dtype = this[type];
                    break;
                }
                pos++;
            }
        }
        return dtype;
    }
}
