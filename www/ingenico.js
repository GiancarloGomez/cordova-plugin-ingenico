var exec         = require('cordova/exec'),
    plugin_name  = 'Ingenico',
    _debug       = window.appSettings && window.appSettings.debug ? window.appSettings.debug : false,
    _style       = 'color:darkorange;margin-left:16px;font-family:\'operator mono ssms\', monospace;';

var Ingenico = {
    /*************************************
     * Authentication
    **************************************/

    initialize: function (apiKey, baseUrl, clientVersion, success, error) {
        if (_debug) { console.log('%cIngenico.js.initialize', _style); }
        exec(function (param) {
            success(Ingenico.isJSON(param) ? JSON.parse(param) : param);
        }, error, plugin_name, 'initialize', [apiKey, baseUrl, clientVersion]);
    },

    login : function(username, password, success, error){
        if (_debug) { console.log('%cIngenico.js.login',_style); }
        exec(function(param){
            success(Ingenico.isJSON(param) ? JSON.parse(param) : param);
        }, error, plugin_name, 'login', [username, password]);
    },

    logoff : function(success, error){
        if (_debug) { console.log('%cIngenico.js.logoff',_style); }
        exec(function(param){
            success(Ingenico.isJSON(param) ? JSON.parse(param) : param);
        }, error, plugin_name, 'logoff', []);
    },

    refreshUserSession : function(success, error){
        if (_debug) { console.log('%cIngenico.js.refreshUserSession',_style); }
        exec(function(param){
            success(Ingenico.isJSON(param) ? JSON.parse(param) : param);
        }, error, plugin_name, 'refreshUserSession', []);
    },

    isInitialized: function (success, error) {
        if (_debug) { console.log('%cIngenico.js.isInitialized', _style); }
        exec(function (param) {
            success(Ingenico.isJSON(param) ? JSON.parse(param) : param);
        }, error, plugin_name, 'isInitialized', []);
    },

    isLoggedIn : function(success, error){
        if (_debug) { console.log('%cIngenico.js.isLoggedIn',_style); }
        exec(function(param){
            success(Ingenico.isJSON(param) ? JSON.parse(param) : param);
        }, error, plugin_name, 'isLoggedIn', []);
    },

    /*************************************
     * Device Information
    **************************************/

    getBatteryLevel : function(success, error){
        if (_debug) { console.log('%cIngenico.js.getBatteryLevel',_style); }
        exec(function(param){
            success(param);
        }, error, plugin_name, 'getBatteryLevel', []);
    },

    getDeviceType : function(success, error){
        if (_debug) { console.log('%cIngenico.js.getDeviceType',_style); }
        exec(function(param){
            success(param);
        }, error, plugin_name, 'getDeviceType', []);
    },

    getDeviceSerialNumber: function (success, error) {
        if (_debug) { console.log('%cIngenico.js.getDeviceSerialNumber', _style); }
        exec(function (param) {
            success(param);
        }, error, plugin_name, 'getDeviceSerialNumber', []);
    },

    /*************************************
     * Device Connection and Setup
    **************************************/

    connect : function(success, error){
        if (_debug) { console.log('%cIngenico.js.connect',_style); }
        exec(function(param){
            let response      = Ingenico.isJSON(param) ? JSON.parse(param) : param,
                dispatchEvent = typeof response !== 'boolean',
                eventResponse = '',
                event;
            // due to continous callbacks we send custom events
            if (dispatchEvent){
                eventResponse = response.split(':');
                event = new CustomEvent(`Ingenico:device:${eventResponse[0]}`,{
                    detail : eventResponse.length > 1 ? eventResponse[1] : ''
                });
                document.dispatchEvent(event);
            }
            if (_debug) {
                console.log('%cIngenico.js.connect.response',_style,response);
                if (dispatchEvent)
                    console.log(`%c\tdispatchEvent => Ingenico:device:${response}`,_style);
            }
           success(typeof response === 'boolean' ? response : true);
        }, error, plugin_name, 'connect', []);
    },

    disconnect : function(success, error){
        if (_debug) { console.log('%cIngenico.js.disconnect',_style); }
        exec(function(param){
           success(Ingenico.isJSON(param) ? JSON.parse(param) : param);
        }, error, plugin_name, 'disconnect', []);
    },

    isDeviceConnected : function(success, error){
        if (_debug) { console.log('%cIngenico.js.isDeviceConnected',_style); }
        exec(function(param){
            success(Ingenico.isJSON(param) ? JSON.parse(param) : param);
        }, error, plugin_name, 'isDeviceConnected', []);
    },

    selectDevice: function (device, success, error) {
        if (_debug) { console.log('%cIngenico.js.selectDevice', _style, device); }
        exec(function (param) {
            let response = Ingenico.isJSON(param) ? JSON.parse(param) : param,
                dispatchEvent = typeof response !== 'boolean',
                eventResponse = '',
                event;
            // due to continous callbacks we send custom events
            if (dispatchEvent) {
                eventResponse = response.split(':');
                event = new CustomEvent(`Ingenico:device:${eventResponse[0]}`, {
                    detail: eventResponse.length > 1 ? eventResponse[1] : ''
                });
                document.dispatchEvent(event);
            }
            if (_debug) {
                console.log('%cIngenico.js.selectDevice.response', _style, response);
                if (dispatchEvent)
                    console.log(`%c\tdispatchEvent => Ingenico:device:${response}`, _style);
            }
            success(typeof response === 'boolean' ? response : true);
        }, error, plugin_name, 'selectDevice', [JSON.stringify(device)]);
    },

    setDeviceType : function(deviceType, success, error){
        if (_debug) { console.log('%cIngenico.js.setDeviceType',_style,deviceType); }
        exec(function(param){
           success(Ingenico.isJSON(param) ? JSON.parse(param) : param);
        }, error, plugin_name, 'setDeviceType', [ deviceType ]);
    },

    setupDevice: function (success, error) {
        if (_debug) { console.log('%cIngenico.js.setupDevice', _style); }
        exec(function (param) {
            success(Ingenico.isJSON(param) ? JSON.parse(param) : param);
        }, error, plugin_name, 'setupDevice', []);
    },

    configureIdleShutdownTimeout: function (timeoutInSeconds, success, error) {
        if (_debug) { console.log('%cIngenico.js.configureIdleShutdownTimeout', _style, timeoutInSeconds); }
        exec(function (param) {
            success(Ingenico.isJSON(param) ? JSON.parse(param) : param);
        }, error, plugin_name, 'configureIdleShutdownTimeout', [timeoutInSeconds]);
    },

    /*************************************
     * Device Search
    **************************************/

    searchForDevice : function(success, error){
        if (_debug) { console.log('%cIngenico.js.searchForDevice',_style); }
        exec(function(param){
           success(Ingenico.isJSON(param) ? JSON.parse(param) : param);
        }, error, plugin_name, 'searchForDevice', []);
    },

    stopSearchForDevice : function(success, error){
        if (_debug) { console.log('%cIngenico.js.stopSearchForDevice',_style); }
        exec(function(param){
           success(Ingenico.isJSON(param) ? JSON.parse(param) : param);
        }, error, plugin_name, 'stopSearchForDevice', []);
    },

    /*************************************
     * Transactions
    **************************************/

    processCashTransaction : function(cashTransaction, success, error){
        if (_debug) { console.log('%cIngenico.js.processCashTransaction',_style,cashTransaction); }
        let transaction = this.prepareTransaction(cashTransaction);
        exec(function(param){
            success(Ingenico.isJSON(param) ? JSON.parse(param) : param);
        }, error, plugin_name, 'processCashTransaction', transaction);
    },

    processCreditSaleTransactionWithCardReader : function(creditSaleTransaction, success, error){
        if (_debug) { console.log('%cIngenico.js.processCreditSaleTransactionWithCardReader',_style,creditSaleTransaction); }
        let transaction = this.prepareTransaction(creditSaleTransaction);
        exec(function(param){
            success(Ingenico.isJSON(param) ? JSON.parse(param) : param);
        }, error, plugin_name, 'processCreditSaleTransactionWithCardReader', transaction);
    },

    processDebitSaleTransactionWithCardReader : function(debitSaleTransaction, success, error){
        if (_debug) { console.log('%cIngenico.js.processDebitSaleTransactionWithCardReader',_style,debitSaleTransaction); }
        let transaction = this.prepareTransaction(debitSaleTransaction);
        exec(function(param){
            success(Ingenico.isJSON(param) ? JSON.parse(param) : param);
        }, error, plugin_name, 'processDebitSaleTransactionWithCardReader', transaction);
    },

    processVoidTransaction : function(originalSaleTransactionID, success, error){
         if (_debug) { console.log('%cIngenico.js.processVoidTransaction',_style,originalSaleTransactionID); }
         exec(function(param){
             success(Ingenico.isJSON(param) ? JSON.parse(param) : param);
         }, error, plugin_name, 'processVoidTransaction', [originalSaleTransactionID]);
    },

    /*************************************
     * Helpers
    **************************************/

    prepareTransaction : function(transaction){
        if (_debug) { console.log('%cIngenico.js.prepareTransaction',_style); }
        let amount             = JSON.stringify(transaction.amount),
            transactionGroupID = transaction.transactionGroupID ? transaction.transactionGroupID : null,
            transactionNotes   = transaction.transactionNotes ? transaction.transactionNotes : null;
        return [amount, transactionGroupID, transactionNotes];
    },

    isJSON : function(value){
        if (_debug) { console.log('%cIngenico.js.isJSON',_style); }
        let isValidJSON = true;
        try { JSON.parse(value);}
        catch(e){ isValidJSON = false; }
        return isValidJSON;
    }
};

module.exports = Ingenico;
