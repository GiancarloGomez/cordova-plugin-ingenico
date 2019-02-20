var exec = require('cordova/exec');

module.exports.login = function (username, password, apiKey, baseUrl, clientVersion, success, error) {
    exec(function(param){
       success(JSON.parse(param));
    }, error, 'IngenicoIonic', 'login', [username, password, apiKey, baseUrl, clientVersion]);
};

module.exports.connect = function (success, error) {
    exec(function(param){
       success(JSON.parse(param));
    }, error, 'IngenicoIonic', 'connect', []);
};

module.exports.disconnect = function (success, error) {
    exec(function(param){
       success(JSON.parse(param));
    }, error, 'IngenicoIonic', 'disconnect', []);
};

module.exports.isDeviceConnected = function (success, error) {
    exec(function(param){
       success(JSON.parse(param));
    }, error, 'IngenicoIonic', 'isDeviceConnected', []);
};

module.exports.onDeviceDisconnected = function (success, error) {
    exec(function(param){
       success(JSON.parse(param));
    }, error, 'IngenicoIonic', 'onDeviceDisconnected', []);
};

module.exports.processCashTransaction = function (cashTransaction, success, error) {
    var  amount = JSON.stringify(cashTransaction.amount);
    var products = JSON.stringify(cashTransaction.products);
    var longitude = cashTransaction.gpsLongitude;
    var latitude = cashTransaction.gpsLatitude;
    var transactionGroupID = (cashTransaction.transactionGroupID == null) ? cashTransaction.transactionGroupID : "";
    exec(function(param){
        success(JSON.parse(param));
    }, error, 'IngenicoIonic', 'processCashTransaction', [
        amount,
        products,
        longitude,
        latitude,
        transactionGroupID
     ]);
};

module.exports.processCreditSaleTransactionWithCardReader = function (creditSaleTransaction, success, error) {
    var  amount = JSON.stringify(creditSaleTransaction.amount);
    var products = JSON.stringify(creditSaleTransaction.products);
    var longitude = (creditSaleTransaction.gpsLongitude == null) ? creditSaleTransaction.gpsLongitude : "";
    var latitude = (creditSaleTransaction.gpsLatitude == null) ? creditSaleTransaction.gpsLatitude : "";
    var transactionGroupID = (creditSaleTransaction.transactionGroupID == null) ? creditSaleTransaction.transactionGroupID : "";
    exec(function(param){
        success(JSON.parse(param));
    }, error, 'IngenicoIonic', 'processCreditSaleTransactionWithCardReader', [
        amount,
        products,
        longitude,
        latitude,
        transactionGroupID
     ]);
};

module.exports.processDebitSaleTransactionWithCardReader = function (debitSaleTransaction, success, error) {
    var amount = JSON.stringify(debitSaleTransaction.amount);
    var products = JSON.stringify(debitSaleTransaction.products);
    var longitude = (debitSaleTransaction.gpsLongitude == null) ? debitSaleTransaction.gpsLongitude : "";
    var latitude = (debitSaleTransaction.gpsLatitude == null) ? debitSaleTransaction.gpsLatitude : "";
    var transactionGroupID = (debitSaleTransaction.transactionGroupID == null) ? debitSaleTransaction.transactionGroupID : "";
    exec(function(param){
        success(JSON.parse(param));
    }, error, 'IngenicoIonic', 'processDebitSaleTransactionWithCardReader', [
        amount,
        products,
        longitude,
        latitude,
        transactionGroupID
     ]);
};

module.exports.setDeviceType = function (deviceType, success, error) {
    exec(function(param){
       success(JSON.parse(param));
    }, error, 'IngenicoIonic', 'setDeviceType', [ deviceType ]);
};

module.exports.searchForDevice = function (success, error) {
    exec(function(param){
       success(JSON.parse(param));
    }, error, 'IngenicoIonic', 'searchForDevice', []);
};

module.exports.stopSearchForDevice = function (success, error) {
    exec(function(param){
       success(JSON.parse(param));
    }, error, 'IngenicoIonic', 'stopSearchForDevice', []);
};

module.exports.selectDevice = function (device, success, error) {
    exec(function(param){
       success(JSON.parse(param));
    }, error, 'IngenicoIonic', 'selectDevice', [ JSON.stringify(device) ]);
};

module.exports.setupDevice = function (success, error) {
    exec(function(param){
       success(JSON.parse(param));
    }, error, 'IngenicoIonic', 'setupDevice', []);
};

module.exports.getReferenceForTransactionWithPendingSignature = function (success, error) {
    exec(function(param){
       success(param);
    }, error, 'IngenicoIonic', 'getReferenceForTransactionWithPendingSignature', []);
};

module.exports.uploadSignature = function (arg0, arg1, success, error) {
    exec(function(param){
       success(param);
    }, error, 'IngenicoIonic', 'uploadSignature', [arg0, arg1]);
};
