# IngenicoIonic Plugin

This repo does not contain the IngenicoMposSdk.framework files as they were too large to push to github. 
These files must be added to your local project under ``./src/ios/frameworks/``

## Installation
All the necessary providers are included with this plugin. Once added to your project, import 
the required providers by doing the following.

### Add to app.module.ts

```javascript
// import 
import { IngenicoProvider } from '../../plugins/cordova-plugin-ionic-ingenico/core/providers';
// add to @NgModule providers
providers: [
    IngenicoProvider
]
```

### Import in your Pages as follows

```javascript
// import in ts file ( based on classes needed - IngenicoProvider is always required )
import {
    Amount,
    CashSaleTransactionRequest,
    CreditSaleTransactionRequest,
    DebitSaleTransactionRequest,
    Device,
    DeviceType,
    IngenicoProvider,
    Product
} from '../../../plugins/cordova-plugin-ionic-ingenico/core/providers';

// add to constructor
constructor(
    public ingenicoProvider: IngenicoProvider
){}
```

## Methods
All methods return a ``Promise``

#### login()
```javascript
this.ingenicoProvider.login(username,password,apiKey,baseUrl,clientVersion)
    .then(result => {})
    .catch(error => {});
```

#### connect()
_Searches for an available device and automatically connects_
```javascript
this.ingenicoProvider.connect()
    .then(result => {
        // add disconnect listener
    })
    .catch(error => {});
```

#### disconnect()
_Disconnects an active Device_
```javascript
this.ingenicoProvider.disconnect()
    .then(result => {})
    .catch(error => {});
```

#### isDeviceConnected()
_Checks if a Device is connected_
```javascript
this.ingenicoProvider.isDeviceConnected()
    .then(result => {})
    .catch(error => {});
```

#### onDeviceDisconnected()
_Listener to add on a succesful result from connect() or setupDevice()_
```javascript
this.ingenicoProvider.onDeviceDisconnected()
    .then(result => {})
    .catch(error => {});
```

#### setDeviceType(DeviceType)
_Set the Device Type for the app to use. This must be done prior to requesting searchForDevice()_
```javascript
this.ingenicoProvider.setDeviceType(DeviceType)
    .then(result => {})
    .catch(error => {});
```

#### searchForDevice(DeviceType)
_Search for Devices for manual setup. Returns an Array of Devices found_
```javascript
this.ingenicoProvider.searchForDevice()
    .then(result => {})
    .catch(error => {});
```

#### stopSearchForDevice(DeviceType)
```javascript
this.ingenicoProvider.stopSearchForDevice()
    .then(result => {})
    .catch(error => {});
```

#### selectDevice(DeviceType)
_Set the selected Device from available Devices ( in manual mode ). Required before setupDevice()_
```javascript
this.ingenicoProvider.selectDevice()
    .then(result => {})
    .catch(error => {});
```

#### setupDevice(DeviceType)
_Configures the selected Device for use ( in manual mode )._
```javascript
this.ingenicoProvider.setupDevice()
    .then(result => {
        // add disconnect listener
    })
    .catch(error => {});
```

#### processCashTransaction(CashSaleTransactionRequest)
```javascript
this.ingenicoProvider.processCashTransaction()
    .then(result => {})
    .catch(error => {});
```

#### processCreditSaleTransactionWithCardReader(CreditSaleTransactionRequest)
```javascript
this.ingenicoProvider.processCreditSaleTransactionWithCardReader()
    .then(result => {})
    .catch(error => {});
```

### processDebitSaleTransactionWithCardReader(DebitSaleTransactionRequest)
```javascript
this.ingenicoProvider.processDebitSaleTransactionWithCardReader()
    .then(result => {})
    .catch(error => {});
```

### uploadSignature(TransactionResult,base64String)
_Send a Base64 Image string for a Transaction Pending Signature which is returned from the getReferenceForTransactionWithPendingSignature() Method._
```javascript
this.ingenicoProvider.uploadSignature(TransactionResult,base64String)
    .then(result => {})
    .catch(error => {});
```

### getReferenceForTransactionWithPendingSignature()
```javascript
this.ingenicoProvider.getReferenceForTransactionWithPendingSignature()
    .then(result => {})
    .catch(error => {});
```
