var exec = require('cordova/exec');

module.exports.login = function (arg0, arg1, success, error) {
    exec(function(param){
       success(JSON.parse(param));
    }, error, 'IngenicoIonic', 'login', [arg0, arg1]);
};

module.exports.connect = function (success, error) {
    exec(function(param){
       success(JSON.parse(param));
    }, error, 'IngenicoIonic', 'connect', []);
};

module.exports.onDeviceDisconnected = function (success, error) {
    exec(function(param){
       success(JSON.parse(param));
    }, error, 'IngenicoIonic', 'onDeviceDisconnected', []);
};

module.exports.processCashTransaction = function (arg0, success, error) {
    var  amount = JSON.stringify(arg0.amount);
    var products = JSON.stringify(arg0.products);
    var longitude = arg0.gpsLongitude;
    var latitude = arg0.gpsLatitude;
    var transactionGroupID = (arg0.transactionGroupID == null) ? arg0.transactionGroupID : "";
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

module.exports.processCreditSaleTransactionWithCardReader = function (arg0, success, error) {
    var  amount = JSON.stringify(arg0.amount);
    var products = JSON.stringify(arg0.products);
    var longitude = (arg0.gpsLongitude == null) ? arg0.gpsLongitude : "";
    var latitude = (arg0.gpsLatitude == null) ? arg0.gpsLatitude : "";
    var transactionGroupID = (arg0.transactionGroupID == null) ? arg0.transactionGroupID : "";
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

module.exports.processDebitSaleTransactionWithCardReader = function (arg0, success, error) {
    var amount = JSON.stringify(arg0.amount);
    var products = JSON.stringify(arg0.products);
    var longitude = (arg0.gpsLongitude == null) ? arg0.gpsLongitude : "";
    var latitude = (arg0.gpsLatitude == null) ? arg0.gpsLatitude : "";
    var transactionGroupID = (arg0.transactionGroupID == null) ? arg0.transactionGroupID : "";
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

module.exports.setDeviceType = function (arg0, success, error) {
    exec(function(param){
       success(JSON.parse(param));
    }, error, 'IngenicoIonic', 'setDeviceType', [ arg0 ]);
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

module.exports.selectDevice = function (arg0, success, error) {
    exec(function(param){
       success(JSON.parse(param));
    }, error, 'IngenicoIonic', 'selectDevice', [ JSON.stringify(arg0) ]);
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
