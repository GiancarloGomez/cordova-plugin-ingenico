module.exports = function(context) {
    var fs = require('fs-extra'),
        p1 = './plugins/cordova-plugin-ingenico/@plugin',
        p2 = './src/providers/ingenico';
    fs.copy(p1,p2, function(err){
      if (err) return console.error(err);
      console.log(`Adding Ionic Native Ingenico Plugin and Models to ${p2}`)
    });
}