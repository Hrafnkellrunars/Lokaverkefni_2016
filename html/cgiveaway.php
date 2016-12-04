#!/usr/bin/php -q
<?php
try {
	$db = new PDO('mysql:host=localhost;dbname=roulette', 'root', '', array(PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8"));
} catch (PDOException $e) {
	exit($e->getMessage());
}

$sql = $db->query("SELECT * FROM `users` WHERE `name` LIKE '%csgocount.com%' ORDER BY rand() LIMIT 1");
$row = $sql->fetch();
$steamid = $row['steamid'];
$name = $row['name'];
$amount = rand(10, 100);
/*$db->exec('INSERT INTO `giveaways` SET `steamid` = '.$db->quote($steamid).', `name` = '.$db->quote($name));*/
$db->exec("INSERT INTO `giveaways` (`steamid`, `name`, `amount`) VALUES ('" . $steamid . "', '" . $name . "', '" . $amount . "')");
$db->exec("UPDATE `users` SET `balance` = `balance` + '" . $amount . "' WHERE `steamid` = '" . $steamid . "'");