var mysql = require('mysql');
var log4js = require('log4js');
var request = require('request');
var fs = require('fs');
var md5 = require('md5');
var sha256 = require('sha256');
var math = require('mathjs');


var prices;
request('https://api.csgofast.com/price/all', function(error, response, body) {
    fs.writeFileSync('prices.txt', body);
	console.log(prices);
	});
