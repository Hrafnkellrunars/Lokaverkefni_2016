var mysql = require('mysql');
var log4js = require('log4js');
var request = require('request');
var fs = require('fs');
var md5 = require('md5');
var sha256 = require('sha256');
var math = require('mathjs');

var connection = mysql.createConnection({
	database: 'roulette',
	host: 'localhost',
	user: 'root',
	password: '3s9yvX3J#9bQkA^ocXMsao&2E214pu'
});

connection.connect(function(err){
  if(err){
    console.log('Error connecting to Db');
    return;
  }
  console.log('Connection established');
});

var body;
request('https://api.csgofast.com/price/all', function(error, response, body) {
	body = JSON.parse(body);
	var text = '';
	for(var key in body) {
		connection.query('INSERT INTO item_values(item,value) VALUES ("'+key+'",'+body[key]+')');
		//text += 'Item: ' + key + '\nValue: ' + body[key]
	}
	//console.log(text);
	console.log("Items inserted.");
	connection.end(function(err) {
	  // The connection is terminated gracefully
	  // Ensures all previously enqueued queries are still
	  // before sending a COM_QUIT packet to the MySQL server.
	});
	
	/*var query = connection.query('INSERT INTO item_values SET ?', {item: 'value'}, responseJson, function(err, result) {
		 if(err) throw err;
		 console.log('data inserted');
	});*/
});

