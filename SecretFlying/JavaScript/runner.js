const jsonify = require('./jsonify'),
	fs = require('fs');

const usage = () => {
	console.log('usage: runner.js /path/to/source.html');
	process.exit(1);
};

let json = '';

try {
	const path = process.argv.pop();
	const html = fs.readFileSync(path, 'utf8');

	json = jsonify(html);
} catch (e) {
	console.error(e);

	usage();
}

if (0 == json.length) {
	usage();
}

console.log(json);