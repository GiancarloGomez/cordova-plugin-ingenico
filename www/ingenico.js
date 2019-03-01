var exec         = require('cordova/exec'),
    plugin_name  = 'Ingenico';

var Ingenico = {
    login : function (username, password, apiKey, baseUrl, clientVersion, success, error) {
        exec(function(param){
           success(JSON.parse(param));
        }, error, plugin_name, 'login', [username, password, apiKey, baseUrl, clientVersion]);
    },

    connect : function (success, error) {
        exec(function(param){
           success(JSON.parse(param));
        }, error, plugin_name, 'connect', []);
    },

    disconnect : function (success, error) {
        exec(function(param){
           success(JSON.parse(param));
        }, error, plugin_name, 'disconnect', []);
    },

    isDeviceConnected : function (success, error) {
        exec(function(param){
           success(JSON.parse(param));
        }, error, plugin_name, 'isDeviceConnected', []);
    },

    onDeviceDisconnected : function (success, error) {
        exec(function(param){
           success(JSON.parse(param));
        }, error, plugin_name, 'onDeviceDisconnected', []);
    },

    processCashTransaction : function (cashTransaction, success, error) {
        let transaction = this.prepareTransaction(cashTransaction);
        exec(function(param){
            success(JSON.parse(param));
        }, error, plugin_name, 'processCashTransaction', transaction);
    },

    processCreditSaleTransactionWithCardReader : function (creditSaleTransaction, success, error) {
        let transaction = this.prepareTransaction(creditSaleTransaction);
        exec(function(param){
            success(JSON.parse(param));
        }, error, plugin_name, 'processCreditSaleTransactionWithCardReader', transaction);
    },

    processDebitSaleTransactionWithCardReader : function (debitSaleTransaction, success, error) {
        let transaction = this.prepareTransaction(debitSaleTransaction);
        exec(function(param){
            success(JSON.parse(param));
        }, error, plugin_name, 'processDebitSaleTransactionWithCardReader', transaction);
    },

    setDeviceType : function (deviceType, success, error) {
        exec(function(param){
           success(JSON.parse(param));
        }, error, plugin_name, 'setDeviceType', [ deviceType ]);
    },

    searchForDevice : function (success, error) {
        exec(function(param){
           success(JSON.parse(param));
        }, error, plugin_name, 'searchForDevice', []);
    },

    stopSearchForDevice : function (success, error) {
        exec(function(param){
           success(JSON.parse(param));
        }, error, plugin_name, 'stopSearchForDevice', []);
    },

    selectDevice : function (device, success, error) {
        exec(function(param){
           success(JSON.parse(param));
        }, error, plugin_name, 'selectDevice', [ JSON.stringify(device) ]);
    },

    setupDevice : function (success, error) {
        exec(function(param){
           success(JSON.parse(param));
        }, error, plugin_name, 'setupDevice', []);
    },

    getReferenceForTransactionWithPendingSignature : function (success, error) {
        exec(function(param){
           success(param);
        }, error, plugin_name, 'getReferenceForTransactionWithPendingSignature', []);
    },

    uploadSignature : function (arg0, arg1, success, error) {
        exec(function(param){
           success(param);
        }, error, plugin_name, 'uploadSignature', [arg0, arg1]);
    },

    prepareTransaction : function (transaction){
        let amount             = JSON.stringify(transaction.amount),
            transactionGroupID = transaction.transactionGroupID ? transaction.transactionGroupID : null,
            transactionNotes   = transaction.transactionNotes ? transaction.transactionNotes : null;
        return [amount, transactionGroupID, transactionNotes];
    }
};

module.exports = Ingenico;
