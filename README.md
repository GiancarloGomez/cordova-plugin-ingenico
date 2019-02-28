# Ingenico Cordova + Ionic Native Plugin 1.0.0

This plugin allows direct interactions with the native Ingenico mPOS SDK through JavaScript functions in your Ionic app. 
This includes creating EMV, Swipe and Cash charges, among other features.

## Ingenico mPOS SDK 1.9.0.8 not included
Before installing this plugin into an Ionic Project you must download Ingenico's mPOS SDK version 1.9.0.8
and save the ``IngenicoMposSdk.framework`` into the ``./src/ios/frameworks/`` folder. This file was too large
to include in the repo and access is required by Ingenico, so it could not be included here.

## Installation
All the necessary providers are included with this plugin. The Ionic Native Plugin and all required Model 
files are installed to ``/src/providers/ingenico`` within your project so they can be easily 
referenced in the import statements.

### Install in Ionic Project
It is recommended that you have a ``plugins_src`` folder in the Ionic Project you are installing to and 
copy the contents of this repo into the following directory ``plugins_src/ingenico-cordova-plugin``. Once all
files are copied run the following command to install in your project.

```bash
ionic cordova plugin add ./plugins_src/ingenico-cordova-plugin
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
this.ingenico.login(username,password,apiKey,baseUrl,clientVersion)
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

#### onDeviceDisconnected()
_Listener to add on a successful result from connect() or setupDevice()_

```javascript
// using connect
this.ingenico.connect()
    .then(result => {
        // setup listener
        this.ingenico.onDeviceDisconnected()
            .then(result => {})
            .catch(error => {});
            })
    .catch(error => {});

// using setupDevice
this.ingenico.setupDevice()
    .then(result => {
        // setup listener
        this.ingenico.onDeviceDisconnected()
            .then(result => {})
            .catch(error => {});
            })
    .catch(error => {});
```

#### setDeviceType(DeviceType)
_Set the Device Type for the app to use. This must be done prior to requesting searchForDevice()_

```javascript
this.ingenico.setDeviceType(DeviceType)
    .then(result => {})
    .catch(error => {});
```

#### searchForDevice(DeviceType)
_Search for Devices for manual setup. Returns an Array of Devices found_

```javascript
this.ingenico.searchForDevice()
    .then(result => {})
    .catch(error => {});
```

#### stopSearchForDevice(DeviceType)
_Stops searching for Devices intiated by searchForDevice()_

```javascript
this.ingenico.stopSearchForDevice()
    .then(result => {})
    .catch(error => {});
```

#### selectDevice(DeviceType)
_Set the selected Device from available Devices ( in manual mode ). Required before setupDevice()_

```javascript
this.ingenico.selectDevice()
    .then(result => {
        // fire off setupDevice() here
    })
    .catch(error => {});
```

#### setupDevice(DeviceType)
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

### uploadSignature(TransactionResult,base64String)
_Send a Base64 Image string for a Transaction Pending Signature which is returned from the getReferenceForTransactionWithPendingSignature() Method._

```javascript
this.ingenico.uploadSignature(TransactionResult,base64String)
    .then(result => {})
    .catch(error => {});
```

### getReferenceForTransactionWithPendingSignature()
_Checks if there is a Transaction pengin a signature upload_

```javascript
this.ingenico.getReferenceForTransactionWithPendingSignature()
    .then(result => {})
    .catch(error => {});
```
