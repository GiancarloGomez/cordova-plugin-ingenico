module.exports = function(context) {
    var fs = require('fs-extra'),
        p1 = './src/providers/ingenico';
    fs.remove(p1, function(err){
      if (err) return console.error(err);
      console.log(`Removing Ionic Native Ingenico Plugin and Models from ${p1}`)
    });
}