var cheerio = require('./cheerio');

var jsonify = function(html) {
	var $ = cheerio.load(html);

	return $('.blogpost_preview_fw.post').map(function() {
		var id;
		try {
			id = $(this).attr('class').match(/post-(\d+)/)[1];
		} catch (e) {
			id = null;
		}

		return {
			'id': id,
			'date': $(this).find('.box_date').text().trim().replace(/\s+/g, ' '),
			'title': $(this).find('.blogpost_title').text().trim(),
			'summary': $(this).find('article.contentarea').text().trim(),
			'thumbnail_url': $(this).find('img.featured_image_standalone').attr('src'),
			'url': $(this).find('a.reamdore').attr('href'),
		};
	}).get();
};

module.exports = jsonify;