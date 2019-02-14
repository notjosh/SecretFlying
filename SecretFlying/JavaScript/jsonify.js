const cheerio = require('./cheerio');

const jsonify = (html) => {
	const $ = cheerio.load(html);

	return $('article')
		.not('.adArcl')
		.map((i, node) => {
		let id;
		try {
			id = $(node).attr('class').match(/post-(\d+)/)[1];
		} catch (e) {
			id = null;
		}

		return {
			id: id,
			date: $(node).find('time.entry-date').attr('datetime'),
			title: $(node).find('.entry-title').text().trim(),
			summary: $(node).find('p').text().trim(),
			thumbnail_url: $(node).find('img.wp-post-image').attr('src'),
			url: $(node).find('a.snews-read-more').attr('href'),
		};
	}).get();
};

module.exports = jsonify;
