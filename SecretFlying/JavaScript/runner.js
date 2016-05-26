var jsonify = require('./jsonify'),
	fs = require('fs');

var usage = function() {
	console.log('usage: runner.js /path/to/source.html');
	process.exit(1);
};

try {
	var path = process.argv.pop();
	var html = fs.readFileSync(path, 'utf8');
	var json = jsonify(html);
} catch (e) {
	usage();
}

if (0 == json.length) {
	usage();
}

console.log(json);