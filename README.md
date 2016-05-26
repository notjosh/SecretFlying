SecretFlying
============

A pretty crude status bar app to see deals from [secretflying.com](http://secretflying.com/).

![](https://s3.amazonaws.com/f.cl.ly/items/0m0B3Y1Z162W1F1V0E0P/Screen%20Shot%202016-05-26%20at%208.59.27%20PM.png?v=bc3d6aec)

It's very unsanctioned, and relies on scraping/parsing, so expect it to fall apart at any minute.

Right now it only scans the European deals (as that's all I'm really interested in), but wouldn't take much to fetch more and aggregate them in.

Getting Started
===============

Building is pretty normal for an app these days.

`pod install`, open `SecretFlying.xcworkspace`, and you should be 95% the way to happiness.

Or, download a build (without autoupdates 🐴) [here](http://hi.notjo.sh/191p0r2q1C2D).

Tidbits
=======

This was my first ~real~ Swift project, so it's pretty rough.

It's using [Cheerio](https://github.com/cheeriojs/cheerio) behind the scenes, because JavaScript has some pretty good tools for dealing with HTML! (It's running in a `JavaScriptCore` context).

TODO
====

 - [ ] Squirrel updates
 - [ ] Toggle regions beyond just European deals
 - [ ] Auto-update feeds, with "new deal" notifications

🛫💁🛬
===

😽