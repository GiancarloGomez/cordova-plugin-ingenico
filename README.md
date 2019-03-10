# Ingenico Cordova + Ionic Native Plugin 1.0.0

This plugin allows direct interactions with the native Ingenico mPOS SDK through JavaScript functions in your Ionic app.
This includes creating EMV, Swipe and Cash charges, among other features.

## Installation
All the necessary providers are included with this plugin. The Ionic Native Plugin and all required Model
files are installed to ``/src/providers/ingenico`` within your project so they can be easily
referenced in the import statements.

### Install in Ionic Project
It is recommended that you have a ``plugins_src`` folder in the Ionic Project you are installing to and
copy the contents of this repo into the following directory ``plugins_src/cordova-plugin-ingenico``. Once all
files are copied run the following command to install in your project.

```bash
ionic cordova plugin add plugins_src/cordova-plugin-ingenico
```

### Add Native Plugin to src/app/app.module.ts

```javascript
// import
import { Ingenico } from '../providers/ingenico';
// add to @NgModule providers
providers: [
    Ingenico
]
```

### Import Plugin and Models in your Pages as follows

```javascript
// import in ts file ( based on classes needed - Ingenico is always required )
import { Ingenico } from '../../providers/ingenico';
import {
    Amount,
    CashSaleTransactionRequest,
    CreditSaleTransactionRequest,
    DebitSaleTransactionRequest,
    Device,
    DeviceType,
    Product
} from '../../providers/ingenico/models';

// add to constructor
constructor(
    public ingenico: Ingenico
){}
```

## Models
Models used within the plugin have been created as Classes and are installed under ``/src/providers/ingenico/models``.
They have been created to match the Ingenico mPOS SDK definitions.

## Methods
All methods return a ``Promise``

#### login()
_Initialize Ingenico with API credentials (username, password and apiKey ), API Base URL and Client Version._

```javascript
this.ingenico.login(username, password, apiKey, baseUrl, clientVersion)
    .then(result => {})
    .catch(error => {});
```

#### connect()
_Searches for an available device and automatically connects_

```javascript
this.ingenico.connect()
    .then(result => {
        // add disconnect listener
    })
    .catch(error => {});
```

#### disconnect()
_Disconnects an active Device_

```javascript
this.ingenico.disconnect()
    .then(result => {})
    .catch(error => {});
```

#### isDeviceConnected()
_Checks if a Device is connected_

```javascript
this.ingenico.isDeviceConnected()
    .then(result => {})
    .catch(error => {});
```

#### setDeviceType(DeviceType)
_Set the Device Type for the app to use. This must be done prior to requesting searchForDevice()_

```javascript
this.ingenico.setDeviceType(DeviceType)
    .then(result => {})
    .catch(error => {});
```

#### searchForDevice()
_Search for Devices for manual setup. Returns an Array of Devices found_

```javascript
this.ingenico.searchForDevice()
    .then(result => {})
    .catch(error => {});
```

#### stopSearchForDevice()
_Stops searching for Devices intiated by searchForDevice()_

```javascript
this.ingenico.stopSearchForDevice()
    .then(result => {})
    .catch(error => {});
```

#### selectDevice(Device)
_Set the selected Device from available Devices ( in manual mode ). Required before setupDevice()_

```javascript
this.ingenico.selectDevice(Device)
    .then(result => {
        // fire off setupDevice() here
    })
    .catch(error => {});
```

#### setupDevice()
_Configures the selected Device for use ( in manual mode )._

```javascript
this.ingenico.setupDevice()
    .then(result => {
        // add disconnect listener
    })
    .catch(error => {});
```

#### processCashTransaction(CashSaleTransactionRequest)
_Processes a cash transaction._

```javascript
this.ingenico.processCashTransaction(CashSaleTransactionRequest)
    .then(result => {})
    .catch(error => {});
```

#### processCreditSaleTransactionWithCardReader(CreditSaleTransactionRequest)
_Processes a Credit Card transaction._

```javascript
this.ingenico.processCreditSaleTransactionWithCardReader(CreditSaleTransactionRequest)
    .then(result => {})
    .catch(error => {});
```

### processDebitSaleTransactionWithCardReader(DebitSaleTransactionRequest)
_Processes a Debit Card transaction._

```javascript
this.ingenico.processDebitSaleTransactionWithCardReader(DebitSaleTransactionRequest)
    .then(result => {})
    .catch(error => {});
```
