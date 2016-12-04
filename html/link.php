<?php
//session_start();
$link = mysql_connect("localhost", "root", "3s9yvX3J#9bQkA^ocXMsao&2E214pu"); // MySQL Host , Username and password
$db_selected = mysql_select_db('roulette', $link); // MySQL Database
mysql_query("SET NAMES utf8");

function fetchinfo($rowname,$tablename,$finder,$findervalue)
{
	if($finder == "1") $result = mysql_query("SELECT $rowname FROM $tablename");
	else $result = mysql_query("SELECT $rowname FROM $tablename WHERE `$finder`='$findervalue'");
	$row = mysql_fetch_assoc($result);
	return $row[$rowname];
}
?>