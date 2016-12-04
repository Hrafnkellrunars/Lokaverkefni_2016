<?php
if (!isset($_GET['page'])) {
	header('Location: /roulette');
	exit();
}

ini_set('display_errors','Off');
try {
	$db = new PDO('mysql:host=localhost;dbname=roulette', 'root', '3s9yvX3J#9bQkA^ocXMsao&2E214pu', array(PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8"));
} catch (PDOException $e) {
	exit($e->getMessage());
}

if (isset($_COOKIE['hash'])) {
	$sql = $db->query("SELECT * FROM `users` WHERE `hash` = " . $db->quote($_COOKIE['hash']));
	if ($sql->rowCount() != 0) {
		$row = $sql->fetch();
		$user = $row;
	}
}

$min = 1000;
$ip = 'localhost';
$referal_summa = 500;
$timestowithdraw = 35000;
$minbetforwithdraw = 20000;
$deposit_online = false;
$withdraw_online = false;

switch ($_GET['page']) {
	
	//Client Errors
	case '404':
		$page = getTemplate('404_page.tpl', array('user'=>$user));
		echo $page;
		break;
	
	case '403':
		$page = getTemplate('403_page.tpl', array('user'=>$user));
		echo $page;
		break;
	//End of Client Errors
	
	case 'roulette':
		$page = getTemplate('roulette.tpl', array('user'=>$user));
		echo $page;
		break;
		
	/*case 'coinflip':
		$sql = $db->query('SELECT * FROM `tickets` WHERE `user` = '.$db->quote($user['steamid']).' AND `status` = 0');
		$page = getTemplate('coinflip.tpl', array('user'=>$user));
		echo $page;
		break;
		
	case 'coingamer':
		$sql = $db->query('SELECT * FROM `tickets` WHERE `user` = '.$db->quote($user['steamid']).' AND `status` = 0');
		$page = getTemplate('coingame.tpl', array('user'=>$user));
		echo $page;
		break;
	case 'coingameend':
		$page = getTemplate('coingameend.tpl', array('user'=>$user));
		echo $page;
		break;
	case 'coinflippast':
		$page = getTemplate('coinflippast.tpl', array('user'=>$user));
		echo $page;
		break;
	case 'coinflipo':
		$page = getTemplate('coinflipo.tpl', array('user'=>$user));
		echo $page;
		break;*/
		
    case 'giveaway':
		$sql = $db->query('SELECT COUNT(`id`) FROM `giveaways`');
		$row = $sql->fetch();
		$count = $row['COUNT(`id`)'];
		$page = getTemplate('giveaway.tpl', array('user'=>$user,'count'=>$count));
		echo $page;
		break;	

	case 'giveaway_enter':
		if(!$user) exit(json_encode(array('success'=>false, 'error'=>'You must login to enter this giveaway.')));
		$name = $db->quote($user['name']);
		$sql = $db->query('SELECT COUNT(`id`) FROM `giveaways` WHERE `steamid` = '.$db->quote($user['steamid']));
		$row = $sql->fetch();
		$count = $row['COUNT(`id`)'];
		if($count != 0) exit(json_encode(array('success'=>false, 'error'=>'You already entered the giveaway.')));
		if(strpos($name, 'csgocrown.gg') !== false) {
			$db->exec('INSERT INTO `giveaways` SET `steamid` = '.$db->quote($user['steamid'].', `name` = '.$db->quote($user['steamid'])));
			exit(json_encode(array('success'=>true,'msg'=>'Thank you - you\'ve entered the giveaway')));
		} else exit(json_encode(array('success'=>false, 'error'=>'You must include CSGOCROWN.GG in your steam name to enter.')));
		break;

	case 'deposit':
		$page = getTemplate('deposit.tpl', array('user'=>$user,'deposit_online' => $deposit_online));
		echo $page;
		break;

	case 'tos':
		$page = getTemplate('tos.tpl', array('user'=>$user));
		echo $page;
		break;
		
    //case 'cgiveaways':
	//	$sql = $db->query('SELECT * FROM `giveaways`');
	//	$row = $sql->fetchAll(PDO::FETCH_ASSOC);
	//	$page = getTemplate('cgiveaways.tpl', array('user'=>$user,'giveaways'=>$row));
	//	echo $page;
	//	break;

	case 'bets':
        $sql = $db->query('SELECT * FROM `bets` WHERE `user` = ' . $db->quote($user['steamid']));
        $row = $sql->fetchAll(PDO::FETCH_ASSOC);
        $page = getTemplate('bets.tpl', array('user' => $user, 'bets' => $row));
        echo $page;
        break;

	case 'support':
		$sql = $db->query('SELECT * FROM `tickets` WHERE `user` = '.$db->quote($user['steamid']).' AND `status` = 0');
		$row = $sql->fetch();
		$ticket = $row;
		if(count($ticket) > 0) {
			$sql = $db->query('SELECT * FROM `messages` WHERE `ticket` = '.$db->quote($ticket['id']));
			$row = $sql->fetchAll();
			$ticket['messages'] = $row;
		}
		$sql = $db->query('SELECT COUNT(`id`) FROM `tickets` WHERE `user` = '.$db->quote($user['steamid']).' AND `status` > 0');
		$row = $sql->fetch();
		$closed = $row['COUNT(`id`)'];
		$tickets = array();
		$sql = $db->query('SELECT * FROM `tickets` WHERE `user` = '.$db->quote($user['steamid']).' AND `status` > 0');
		while ($row = $sql->fetch()) {
			$s = $db->query('SELECT `message`, `user` FROM `messages` WHERE `ticket` = '.$db->quote($row['id']));
			$r = $s->fetchAll();
			$tickets[] = array('title'=>$row['title'],'messages'=>$r);
		}
		$page = getTemplate('support.tpl', array('user'=>$user,'ticket'=>$ticket,'open'=>(count($ticket) > 1)?1:0,'closed'=>$closed,'tickets'=>$tickets));
		echo $page;
		break;
		

	case 'support_new':
		if(!$user) exit(json_encode(array('success'=>false, 'error'=>'You must login to access the support.')));
		$tid = $_POST['tid'];
		$title = $_POST['title'];
		$body = $_POST['reply'];
		$close = $_POST['close'];
		$cat = $_POST['cat'];
		$flag = $_POST['flag'];
		$lmao = $_POST['lmao'];
		if($tid == 0) {
			if((strlen($title) < 0) || (strlen($title) > 256)) exit(json_encode(array('success'=>false, 'error'=>'Title < 0 or > 256.')));
			if(($cat < 0) || ($cat > 4)) exit(json_encode(array('success'=>false, 'error'=>'Department cannot be left blank.')));
			if((strlen($body) < 0) || (strlen($body) > 2056)) exit(json_encode(array('success'=>false, 'error'=>'Description cannot be left blank.')));
			$sql = $db->query('SELECT COUNT(`id`) FROM `tickets` WHERE `user` = '.$db->quote($user['steamid']).' AND `status` = 0');
			$row = $sql->fetch();
			$count = $row['COUNT(`id`)'];
			if($count != 0) exit(json_encode(array('success'=>false, 'error'=>'You already have a pending support ticket.')));
			$db->exec('INSERT INTO `tickets` SET `time` = '.$db->quote(time()).', `user` = '.$db->quote($user['steamid']).', `cat` = '.$db->quote($cat).', `title` = '.$db->quote($title));
			$id = $db->lastInsertId();
			$db->exec('INSERT INTO `messages` SET `ticket` = '.$db->quote($id).', `message` = '.$db->quote($body).', `user` = '.$db->quote($user['steamid']).', `time` = '.$db->quote(time()));
			exit(json_encode(array('success'=>true,'msg'=>'Thank you - your ticket has been submitted ('.$id.')')));
		} else {
			$sql = $db->query('SELECT * FROM `tickets` WHERE `id` = '.$db->quote($tid).' AND `user` = '.$db->quote($user['steamid']));
			if($sql->rowCount() > 0) {
				$row = $sql->fetch();
				if($close == 1) {
					$db->exec('UPDATE `tickets` SET `status` = 1 WHERE `id` = '.$db->quote($tid));
					exit(json_encode(array('success'=>true,'msg'=>'[CLOSED]')));
				}
				$db->exec('INSERT INTO `messages` SET `ticket` = '.$db->quote($tid).', `message` = '.$db->quote($body).', `user` = '.$db->quote($user['steamid']).', `time` = '.$db->quote(time()));
				exit(json_encode(array('success'=>true,'msg'=>'Response added.')));
			}
		}
		break;

	case 'adminsupport':
		if(($user['rank'] == "99") OR ($user['rank'] == "100") OR ($user['rank'] == "4")) {
			if(isset($_GET['id'])) {
				$sql = $db->query('SELECT * FROM `tickets` WHERE `id` = '.$db->quote($_GET['id']));
				$row = $sql->fetch();
				$ticket = $row;
				if(count($ticket) > 0) {
					$sql = $db->query('SELECT * FROM `messages` WHERE `ticket` = '.$db->quote($ticket['id']));
					$row = $sql->fetchAll();
					$ticket['messages'] = $row;
				}
				$sql = $db->query('SELECT COUNT(`id`) FROM `tickets` WHERE `status` > 0');
				$row = $sql->fetch();
				$closed = $row['COUNT(`id`)'];
				$tickets = array();
				$sql = $db->query('SELECT * FROM `tickets` WHERE `status` > 0');
				while ($row = $sql->fetch()) {
					$s = $db->query('SELECT `message`, `user` FROM `messages` WHERE `ticket` = '.$db->quote($row['id']));
					$r = $s->fetchAll();
					$tickets[] = array('title'=>$row['title'],'messages'=>$r);
				}
				$page = getTemplate('adminsupport.tpl', array('user'=>$user,'ticket'=>$ticket,'open'=>(count($ticket) > 1)?1:0,'closed'=>$closed,'tickets'=>$tickets));
			} else {
				$sql = $db->query('SELECT * FROM `tickets` WHERE `status` != 1');
				$row = $sql->fetchAll(PDO::FETCH_ASSOC);
				$page = getTemplate('adminsupport.tpl', array('user'=>$user,'ticketlist'=>$row));
			}
		} else {
			$page = getTemplate('support.tpl', array('user'=>$user));
		}
		echo $page;
		break;
		
	case 'support_reply':
		if(($user['rank'] == "99") OR ($user['rank'] == "100") OR ($user['rank'] == "4")) {
			if(!$user) exit(json_encode(array('success'=>false, 'error'=>'You must login to access the support.')));
			$tid = $_POST['tid'];
			$body = $_POST['reply'];
			$close = $_POST['close'];
			$sql = $db->query('SELECT * FROM `tickets` WHERE `id` = '.$db->quote($tid).'');
			if($sql->rowCount() > 0) {
				$row = $sql->fetch();
				if($close == 1) {
					$db->exec('UPDATE `tickets` SET `status` = 1 WHERE `id` = '.$db->quote($tid));
					exit(json_encode(array('success'=>true,'msg'=>'[CLOSED]')));
				}
				$db->exec('INSERT INTO `messages` SET `ticket` = '.$db->quote($tid).', `message` = '.$db->quote($body).', `user` = '.$db->quote($user['steamid']).', `time` = '.$db->quote(time()));
				exit(json_encode(array('success'=>true,'msg'=>'Response added.')));
			}
		} else {
			exit(json_encode(array('success'=>false,'msg'=>'Not authorized!')));
		}
		break;

	case 'rolls':
		if(isset($_GET['id'])) {
			$id = $_GET['id'];
			if(!preg_match('/^[0-9]+$/', $id)) exit();
			$sql = $db->query('SELECT * FROM `hash` WHERE `id` = '.$db->quote($id));
			$row = $sql->fetch();
			$sql = $db->query('SELECT * FROM `rolls` WHERE `hash` = '.$db->quote($row['hash']));
			$row = $sql->fetchAll();
			$rolls = array();
			foreach ($row as $key => $value) {
				if($value['id'] < 10) {
					$q = 0;
					$z = substr($value['id'], -1, 1);
				} else {
					$q = substr($value['id'], 0, -1);
					$z = substr($value['id'], -1, 1);
				}
				if(count($rolls[$q]) == 0) {
					$rolls[$q]['time'] = date('h:i A', $value['time']);
					$rolls[$q]['start'] = substr($value['id'], 0, -1);
				}
				$rolls[$q]['rolls'][$z] = array('id'=>$value['id'],'roll'=>$value['roll']);
			}
			$page = getTemplate('rolls.tpl', array('user'=>$user,'rolls'=>$rolls));
		} else {
			$sql = $db->query('SELECT * FROM `hash` ORDER BY `id` DESC');
			$row = $sql->fetchAll();
			$rolls = array();
			foreach ($row as $key => $value) {
				$s = $db->query('SELECT MIN(`id`) AS min, MAX(`id`) AS max FROM `rolls` WHERE `hash` = '.$db->quote($value['hash']));
				$r = $s->fetch();
				$rolls[] = array('id'=>$value['id'],'date'=>date('Y-m-d', $value['time']),'seed'=>$value['hash'],'rolls'=>$r['min'].'-'.$r['max'],'time'=>$value['time']);
			}
			$page = getTemplate('rolls.tpl', array('user'=>$user,'rolls'=>$rolls));
		}
		echo $page;
		break;

	case 'faq':
		$page = getTemplate('faq.tpl', array('user'=>$user));
		echo $page;
		break;

	case 'affiliates':
		$affiliates = array();
		$sql = $db->query('SELECT `code` FROM `codes` WHERE `user` = '.$db->quote($user['steamid']));
		if($sql->rowCount() == 0) {
			$affiliates = array(
				'visitors' => 0,
				'total_bet' => 0,
				'lifetime_earnings' => 0,
				'available' => 0,
				'level' => "<b style='color:#965A38'><i class='fa fa-star'></i> Bronze</b> (1 coin per 300 bet)",
				'depositors' => "0/50 to silver",
				'code' => '(You dont have promocode)'
				);
		} else {
			$row = $sql->fetch();
			$affiliates['code'] = $row['code'];
			$sql = $db->query('SELECT * FROM `users` WHERE `referral` = '.$db->quote($user['steamid']));
			$reffersN = $sql->fetchAll();
			$reffers = array();
			$affiliates['visitors'] = 0;
			$count = 0;
			$affiliates['total_bet'] = 0;
			foreach ($reffersN as $key => $value) {
				$sql = $db->query('SELECT SUM(`amount`) AS amount FROM `bets` WHERE `user` = '.$db->quote($value['steamid']));
				$row = $sql->fetch();
				if($row['amount'] == 0)
					$affiliates['visitors']++;
				else
					$count++;
				$affiliates['total_bet'] += $row['amount'];
				$s = $db->query('SELECT SUM(`amount`) AS amount FROM `bets` WHERE `user` = '.$db->quote($value['steamid']).' AND `collect` = 0');
				$r = $s->fetch();
				$reffers[] = array('player'=>substr_replace($value['steamid'], '*************', 0, 13),'total_bet'=>$row['amount'],'collect_coins'=>$r['amount'],'comission'=>0);
			}
			if($count < 50) {
				$affiliates['level'] = "<b style='color:#965A38'><i class='fa fa-star'></i> Silver IV</b> (1 coin per 300 bet)";
				$affiliates['depositors'] = $count."/50 to Legendary Eagle";
				$s = 300;
			} elseif($count > 50) {
				$affiliates['level'] = "<b style='color:#A9A9A9'><i class='fa fa-star'></i> Legendary Eagle</b> (1 coin per 200 bet)";
				$affiliates['depositors'] = $count."/200 to Global elite";
				$s = 200;
			} elseif($count > 200) {
				$affiliates['level'] = "<b style='color:#FFD700'><i class='fa fa-star'></i> Global elite</b> (1 coin per 100 bet)";
				$affiliates['depositors'] = $count."/8 to 8";
				$s = 100;
			}
			$affiliates['available'] = 0;
			$affiliates['lifetime_earnings'] = 0;
			foreach ($reffers as $key => $value) {
				$reffers[$key]['comission'] = round($value['total_bet']/$s, 0);
				$affiliates['available'] += round($value['collect_coins']/$s, 0);
				$affiliates['lifetime_earnings'] += round($value['total_bet']/$s, 0)-round($value['collect_coins']/$s, 0);
			}
			$affiliates['reffers'] = $reffers;
		}
		$page = getTemplate('affiliates.tpl', array('user'=>$user, 'affiliates'=>$affiliates));
		echo $page;
		break;

	case 'changecode':
		if(!$user) exit(json_encode(array('success'=>false, 'error'=>'You must login to access the changecode.')));
		$code = $_POST['code'];
		if(!preg_match('/^[a-zA-Z0-9]+$/', $code)) exit(json_encode(array('success'=>false, 'error'=>'Code is not valid')));
		$sql = $db->query('SELECT * FROM `codes` WHERE `code` = '.$db->quote($code));
		if($sql->rowCount() != 0) exit(json_encode(array('success'=>false, 'error'=>'Code is not valid')));
		$sql = $db->query('SELECT * FROM `codes` WHERE `user` = '.$db->quote($user['steamid']));
		if($sql->rowCount() == 0) {
			$db->exec('INSERT INTO `codes` SET `code` = '.$db->quote($code).', `user` = '.$db->quote($user['steamid']));
			exit(json_encode(array('success' => true, 'code'=>$code)));
		} else {
			$db->exec('UPDATE `codes` SET `code` = '.$db->quote($code).' WHERE `user` = '.$db->quote($user['steamid']));
			exit(json_encode(array('success' => true, 'code'=>$code)));
		}
		break;

	case 'collect':
		if(!$user) exit(json_encode(array('success'=>false, 'error'=>'You must login to access the collect.')));
		$sql = $db->query('SELECT * FROM `users` WHERE `referral` = '.$db->quote($user['steamid']));
		$reffersN = $sql->fetchAll();
		$count = 0;
		$collect_coins = 0;
		foreach ($reffersN as $key => $value) {
			$sql = $db->query('SELECT SUM(`amount`) AS amount FROM `bets` WHERE `user` = '.$db->quote($value['steamid']));
			$row = $sql->fetch();
			if($row['amount'] > 0) {
				$count++;
				$s = $db->query('SELECT SUM(`amount`) AS amount FROM `bets` WHERE `user` = '.$db->quote($value['steamid']).' AND `collect` = 0');
				$r = $s->fetch();
				$db->exec('UPDATE `bets` SET `collect` = 1 WHERE `user` = '.$db->quote($value['steamid']));
				$collect_coins += $r['amount'];
			}
		}
		if($count < 50) {
			$s = 300;
		} elseif($count > 50) {
			$s = 200;
		} elseif($count > 200) {
			$s = 100;
		}
		$collect_coins = round($collect_coins/$s, 0);
		$db->exec('UPDATE `users` SET `balance` = `balance` + '.$collect_coins.' WHERE `steamid` = '.$db->quote($user['steamid']));
		exit(json_encode(array('success'=>true, 'collected'=>$collect_coins)));
		break;

	case 'promo':
		if(!$user) exit(json_encode(array('success'=>false, 'error'=>'You must login to access the redeem.')));
		if($user['referral'] != '0') exit(json_encode(array('success'=>false, 'error'=>'You have already redeemed a code. Only 1 code allowed per account.', 'code'=>$user['referral'])));
		$out = curl('http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=3A55F2630BA3CDE94E33D78745659B6F&steamid='.$user['steamid'].'&format=json');
		$out = json_decode($out, true);
		if(!$out['response']) exit(json_encode(array('success'=>false, 'error'=>'You profile is private')));
		$csgo = false;
		foreach ($out['response']['games'] as $key => $value) {
			if($value['appid'] == 730) $csgo = true;
		}
		if(!$csgo) exit(json_encode(array('success'=>false, 'error'=>'You dont have CS:GO.')));
		$code = $_GET['code'];
		if(!preg_match('/^[a-zA-Z0-9]+$/', $code)) {
			exit(json_encode(array('success'=>false, 'error'=>'Code is not valid')));
		} else {
			$sql = $db->query('SELECT * FROM `codes` WHERE `code` = '.$db->quote($code));
			if($sql->rowCount() != 0) {
				$row = $sql->fetch();
				if($row['user'] == $user['steamid']) exit(json_encode(array('success'=>false, 'error'=>'This is you referal code')));
				//$db->exec('UPDATE `users` SET `referral` = '.$db->quote($row['user']).', `balance` = `balance` + '.$referal_summa.' WHERE `steamid` = '.$db->quote($user['steamid']));
				$db->exec('UPDATE `users` SET `referral` = '.$db->quote($row['user']).', `balance` = `balance` + 500000 WHERE `steamid` = '.$db->quote($user['steamid']));
				exit(json_encode(array('success'=>true, 'credits'=>$referal_summa)));
			} else {
				exit(json_encode(array('success'=>false, 'error'=>'Code not found')));
			}
		}
		break;
		
	case 'bonus':
		if(!$user) exit(json_encode(array('success'=>false, 'error'=>'You must login to access the redeem.')));
		$bonuscode = $_GET['code'];
		$out = curl('http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=3A55F2630BA3CDE94E33D78745659B6F&steamid='.$user['steamid'].'&format=json');
		$out = json_decode($out, true);
		if(!$out['response']) exit(json_encode(array('success'=>false, 'error'=>'Your profile is private.')));
		$csgo = false;
		foreach ($out['response']['games'] as $key => $value) {
			if($value['appid'] == 730) $csgo = true;
		}
		if(!$csgo) exit(json_encode(array('success'=>false, 'error'=>'You dont have CS:GO.')));
		if(!preg_match('/^[a-zA-Z0-9-]+$/', $bonuscode)) {
			exit(json_encode(array('success'=>false, 'error'=>'Code is not valid')));
		} else {
			$sql = $db->query('SELECT COUNT(`id`) FROM `bonuscode` WHERE `used` = 1 && `code` = "'.$bonuscode.'"');
			$row = $sql->fetch();
			$count = $row['COUNT(`id`)'];
			if($count > 0) exit(json_encode(array('success'=>false, 'error'=>'Bonus Code already used.')));
			$db->exec('UPDATE `bonuscode` SET `used` = 1 WHERE `code` = "'.$bonuscode.'"');
			$sql = $db->query('SELECT * FROM `bonuscode` WHERE `code` = "'.$bonuscode.'"');
			if($sql->rowCount() != 0) {
				$row = $sql->fetch();
				$amount = $row['amount'];
				$db->exec('UPDATE `users` SET `balance` = `balance` + '.$amount.' WHERE `steamid` = '.$db->quote($user['steamid']));
				exit(json_encode(array('success'=>true, 'credits'=>$amount)));
			} else {
				exit(json_encode(array('success'=>false, 'error'=>'Bonus Code not found')));
			}
		}
		break;

	case 'withdraw':
		$sql = $db->query('SELECT `id` FROM `bots`');
		$ids = array();
		while ($row = $sql->fetch()) {
			$ids[] = $row['id'];
		}
		$page = getTemplate('withdraw.tpl', array('user'=>$user,'bots'=>$ids,'withdraw_online'=>$withdraw_online));
		echo $page;
		break;

	case 'transfers':
		$sql = $db->query('SELECT * FROM `transfers` WHERE `to1` = '.$db->quote($user['steamid']).' OR `from1` = '.$db->quote($user['steamid']));
		$row = $sql->fetchAll(PDO::FETCH_ASSOC);
		$page = getTemplate('transfers.tpl', array('user'=>$user,'transfers'=>$row));
		echo $page;
		break;

	case 'offers':
		$sql = $db->query('SELECT * FROM `trades` WHERE `user` = '.$db->quote($user['steamid']));
		$row = $sql->fetchAll(PDO::FETCH_ASSOC);
		$page = getTemplate('offers.tpl', array('user'=>$user,'offers'=>$row));
		echo $page;
		break;


    case 'login':
        include 'openid.php';
        try {
			$openid = new LightOpenID('http://'.$_SERVER['SERVER_NAME'].'/');
			if (!$openid->mode) {
				$openid->identity = 'http://steamcommunity.com/openid/';
				header('Location: ' . $openid->authUrl());
			} elseif ($openid->mode == 'cancel') {
				echo '';
			} else {
                if ($openid->validate()) {
                    $id = $openid->identity;
                    $ptn = "/^http:\/\/steamcommunity\.com\/openid\/id\/(7[0-9]{15,25}+)$/";
                    preg_match($ptn, $id, $matches);

                    $url = "http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=AA2775849280A8D06D3BD65563F203FE&steamids=$matches[1]";
                    $json_object = file_get_contents($url);
                    $json_decoded = json_decode($json_object);
                    foreach ($json_decoded->response->players as $player) {
                        $steamid = $player->steamid;
                        $name = $player->personaname;
                        $cens = array('script', 'www', 'http://', '.ru', '.ro', '.mk', '.net', '.org', 'fuck', 'dick', 'morti', 'mata', 'ma-ta', 'mortii', 'pula', 'coae', 'coaie', 'boase', '<', '>', 'csgox14.com', 'csgoempire.com', 'csgofast.com', 'csgopayload.com', 'csgoraffling.com', 'csgopulse.com', 'csgobigwin.com', 'csbahis.com', 'csgochips.com', 'csgo-trio.com', 'csgohide.com', 'onionpot.eu', 'skinjackpot.net', 'csgoezy.com', 'skinomat.com', 'csgorumble.com', 'csgorandom.pl', 'csgobankbot.com', 'csgohs.com', 'ninjackpot.co', 'skinsproject.pl', 'skincrates.com', 'rafflesparty.com', 'skinodds.com', 'csgorain.us', 'joyskins.top', 'stonefire.io', 'csgolike.com', 'csbombergo.com', 'csgofp.com', 'CSGOHILL.com', 'csgokebab.com', 'csgoscares.com', 'get-skins.com', 'csgo.best', 'skillnocheats.pl', 'oneleday.com', 'bid4skins.pl', 'csbetgo.com', 'csgowheel.com', 'loscsgo.com', 'csgorides.com', 'csgojoe.com', 'csgoldpot.com', 'csgofifty.com', 'csgo.pink', 'csgoroot.com', 'csgorullete.eu', 'csgoskinslotto.com', 'm9snik-csgo.com', 'skinzbid.com', 'csgohowl.eu', 'csgoreaper.com', 'csgodirty.com', 'csgooffline.com', 'csgo500.com', 'csgoimpact.com', 'itemgrad.com', 'csgoduck.com', 'csgo-x.pro', 'csgotune.com', 'csgoskinny.com', 'csgocenter.com', 'csgobro.pro', 'csgosuites.com', 'csgo-house.com', 'csgowonder.com', 'csgoufo.com', 'csgobull.com', 'csgoloto.com', 'skinwin.club', 'csgoswapper.com', 'csgospeed.com', 'skinsanity.gg', 'skinsez.com', 'society.gg', 'csgetto.com', 'skinzbid.com', 'csgoshadow.com', 'csgohell.eu', 'csgocasepot.eu', 'csgo.porn', 'csgopoints.com', 'csgopoints.com', 'csgobird.com', 'csgoweb.com', 'easy.gl', 'csgofairplay.com', 'csgorivalry.com', 'ninjackpot.com', 'csgoforest.com', 'csgo-fight.com', 'csgobiz.com', 'csgoblaze.com', 'csgoburn.com', 'csgostep.com', 'csgofade.net', 'hdaq.tk', 'csgohf.ru', 'csgobattle.com', 'csgoatse.com', 'csgo.mk', 'csgo-gambler.com', 'csgorage.com', 'csgostakes.com', 'csgowest.com', 'csgodicegame.com', 'csgomotion.us', 'csgorambopot.com', 'csgoegg.com', 'csgoinfinite.com', 'winaskin.com', 'csgo9.com', 'csgohoney.us', 'csgohouse.com', 'csgohill.com', 'csgostrong.com', 'kickback.com', 'csgo2x.com', 'csgobrawl.com');
                        $name = str_ireplace($cens, '*', $name);
                        $avatar = $player->avatar;
                    }

                    $hash = md5($steamid . time() . rand(1, 9999999999999999));
                    $sql = $db->query("SELECT * FROM `users` WHERE `steamid` = '" . $steamid . "'");
                    $row = $sql->fetchAll(PDO::FETCH_ASSOC);
                    if (count($row) == 0) {
                        $db->exec("INSERT INTO `users` (`hash`, `steamid`, `name`, `avatar`) VALUES ('" . $hash . "', '" . $steamid . "', " . $db->quote($name) . ", '" . $avatar . "')");
                    } else {
                        $db->exec("UPDATE `users` SET `hash` = '" . $hash . "', `name` = " . $db->quote($name) . ", `avatar` = '" . $avatar . "' WHERE `steamid` = '" . $steamid . "'");
                    }
                    setcookie('hash', $hash, time() + 3600 * 24 * 7, '/');
                    header('Location: /EU872893742837947923.php?id=' . $hash);
                }
            }
        } catch (ErrorException $e) {
            exit($e->getMessage());
        }
        break;

    case 'get_inv':
        if (!$user) exit(json_encode(array('success' => false, 'error' => 'You must login to access the deposit.')));
        if ((file_exists('cache/' . $user['steamid'] . '.txt')) && (!isset($_GET['nocache']))) {
            $array = file_get_contents('cache/' . $user['steamid'] . '.txt');
            $array = unserialize($array);
            $array['fromcache'] = true;
            if (isset($_COOKIE['tid'])) {
                $sql = $db->query('SELECT * FROM `trades` WHERE `id` = ' . $db->quote($_COOKIE['tid']) . ' AND `status` = 0');
                if ($sql->rowCount() != 0) {
                    $row = $sql->fetch();
                    $array['code'] = $row['code'];
                    $array['amount'] = $row['summa'];
                    $array['tid'] = $row['id'];
                    $array['bot'] = "Bot #" . $row['bot_id'];
                } else {
                    setcookie("tid", "", time() - 3600, '/');
                }
            }
            exit(json_encode($array));
        }
        $prices = file_get_contents('XeqB54&67wn2!d^eR#TKj4ufZZ.txt');
        $prices = json_decode($prices, true);
        $inv = curl('https://steamcommunity.com/profiles/' . $user['steamid'] . '/inventory/json/730/2/');
        $inv = json_decode($inv, true);
        if ($inv['success'] != 1) {
            exit(json_encode(array('error' => 'Your profile is private. Please <a href="http://steamcommunity.com/my/edit/settings" target="_blank">set your inventory to public</a> and <a href="javascript:loadLeft(\'nocache\')">try again</a>.')));
        }
        $items = array();
        foreach ($inv['rgInventory'] as $key => $value) {
            $id = $value['classid'] . '_' . $value['instanceid'];
            $trade = $inv['rgDescriptions'][$id]['tradable'];
            if (!$trade) continue;
            $name = $inv['rgDescriptions'][$id]['market_hash_name'];
            $price = $prices[$name] * 1000;
            $img = 'http://steamcommunity-a.akamaihd.net/economy/image/' . $inv['rgDescriptions'][$id]['icon_url'];
            if ((preg_match('/(Graffiti|Sticker|Souvenir)/', $name)) || ($price < $min)) {
                $price = 0;
                $reject = 'Junk';
            } else {
                $reject = 'unknown item';
            }
            $items[] = array(
                'assetid' => $value['id'],
                'bt_price' => "0.00",
                'img' => $img,
                'name' => $name,
                'price' => $price,
                'reject' => $reject,
                'sa_price' => $price,
                'steamid' => $user['steamid']);
        }
        $array = array(
            'error' => 'none',
            'fromcache' => false,
            'items' => $items,
            'success' => true);
        if (isset($_COOKIE['tid'])) {
            $sql = $db->query('SELECT * FROM `trades` WHERE `id` = ' . $db->quote($_COOKIE['tid']) . ' AND `status` = 0');
            if ($sql->rowCount() != 0) {
                $row = $sql->fetch();
                $array['code'] = $row['code'];
                $array['amount'] = $row['summa'];
                $array['tid'] = $row['id'];
                $array['bot'] = "Bot #" . $row['bot_id'];
            } else {
                setcookie("tid", "", time() - 3600, '/');
            }
        }
        file_put_contents('cache/' . $user['steamid'] . '.txt', serialize($array), LOCK_EX);
        exit(json_encode($array));
        break;	

	
	
    case 'deposit_countse_js':
        if (!$user) exit(json_encode(array('success' => false, 'error' => 'You must login to access the deposit.')));
        if ($_COOKIE['tid']) {
            exit(json_encode(array('success' => false, 'error' => 'You isset active tradeoffer.')));
        }
        $prices = file_get_contents('XeqB54&67wn2!d^eR#TKj4ufZZ.txt');
        $prices = json_decode($prices, true);
        $inv = curl('https://steamcommunity.com/profiles/' . $user['steamid'] . '/inventory/json/730/2/');
        //die($inv);
        $inv = json_decode($inv, true);
        if ($inv['success'] != 1) {
            exit(json_encode(array('error' => 'Your profile is private. Please <a href="http://steamcommunity.com/my/edit/settings" target="_blank">set your inventory to public</a> and <a href="javascript:loadLeft(\'nocache\')">try again</a>.')));
        }
        $kek = 0;
        $assetids = split(',', $_GET['assetids']);
        foreach ($inv['rgInventory'] as $key => $value) {
			if($kek != 0) break;
            $id = $value['classid'] . '_' . $value['instanceid'];
            $name = $inv['rgDescriptions'][$id]['market_hash_name'];
            for ($i = 0; $i < count(assetids); $i++) {
				if($kek != 0) break;
                if ((preg_match('/(Graffiti|Sticker|Souvenir)/', $name) and $assetids[$i] == $value['id']) || ($prices[$name]* 1000 < $min  and $assetids[$i] == $value['id'])) {
                  $kek++;
                }
            }
        }
       
        $sql = $db->query('SELECT `id`,`name` FROM `bots` ORDER BY rand() LIMIT 1');
        $row = $sql->fetch();
        $bot = $row['id'];
		$partner = extract_partner(filter_var($_GET['tradeurl'], FILTER_VALIDATE_URL));
		$token = extract_token(filter_var($_GET['tradeurl'], FILTER_VALIDATE_URL));
		setcookie('tradeurl', filter_var($_GET['tradeurl'], FILTER_VALIDATE_URL), time() + 3600 * 24 * 7, '/');
		$checksum = intval(filter_var($_GET['checksum'], FILTER_VALIDATE_URL));

        $out = curl('http://' . $ip . ':' . (2634 + $bot) . '/EuDepozitezIteme827192728292739127/?assetids=' . $_GET['assetids'] . '&partner=' . $partner . '&token=' . $token . '&checksum=' . $_GET['checksum'] . '&steamid=' . $user['steamid']);
        $out = json_decode($out, true);
        $out['bot'] = $row['name'];
        if ($out['success'] == true) {
            $s = 0;
            foreach ($out['items'] as $key => $value) {
                $db->exec('INSERT INTO `items` SET `trade` = ' . $db->quote($out['tid']) . ', `market_hash_name` = ' . $db->quote($value['market_hash_name']) . ', `img` = ' . $db->quote($value['icon_url']) . ', `botid` = ' . $db->quote($bot) . ', `time` = ' . $db->quote(time()));
                $s += $prices[$value['market_hash_name']] * 1000;
            }
            $db->exec('INSERT INTO `trades` SET `id` = ' . $db->quote($out['tid']) . ', `bot_id` = ' . $db->quote($bot) . ', `code` = ' . $db->quote($out['code']) . ', `status` = 0, `user` = ' . $db->quote($user['steamid']) . ', `summa` = ' . $db->quote($s) . ', `time` = ' . $db->quote(time()));
            $out['amount'] = $s;
            setcookie('tid', $out['tid'], time() + 3600 * 24 * 7, '/');
        }
        exit(json_encode($out));
        break;
		

	case 'confirm':
	if(!$user) exit(json_encode(array('success'=>false, 'error'=>'You must login to access the confirm.')));
		$tid = (int)$_GET['tid'];
		$sql = $db->query('SELECT * FROM `trades` WHERE `id` = '.$db->quote($tid));
		$row = $sql->fetch();
		$out = curl('http://'.$ip.':'.(2634+$row['bot_id']).'/EuVerificTradeul?tid='.$row['id']);
		$out = json_decode($out, true);
		if(($out['success'] == true) && ($out['action'] == 'accept') && ($row['status'] != 1)) {
		if($row['summa'] > 0) $db->exec('UPDATE `users` SET `balance` = `balance` + '.$row['summa'].' WHERE `steamid` = '.$db->quote($user['steamid']));
		if($row['summa'] > 0) $db->exec('UPDATE `users` SET `deposit` = `deposit` + '.$row['summa'].' WHERE `steamid` = '.$db->quote($user['steamid']));
		if($row['summa'] > 0) $db->exec('UPDATE `items` SET `status` = 1 WHERE `trade` = '.$db->quote($row['id']));
		if($row['summa'] > 0) $db->exec('UPDATE `trades` SET `status` = 1 WHERE `id` = '.$db->quote($row['id']));
			setcookie("tid", "", time() - 3600, '/');
		} elseif(($out['success'] == true) && ($out['action'] == 'cross')) {
			setcookie("tid", "", time() - 3600, '/');
			$db->exec('DELETE FROM `items` WHERE `trade` = '.$db->quote($row['id']));
			$db->exec('DELETE FROM `trades` WHERE `id` = '.$db->quote($row['id']));
		} else {
			exit(json_encode(array('success'=>false, 'error'=>'Trade is in procces or the coins are already credited')));
		}
		exit(json_encode($out));
		break;
		

    case 'get_bank_safe':
        if (!$user) exit(json_encode(array('success' => false, 'error' => 'You must login to access the widthdraw.')));
        $g = curl('https://www.google.com/recaptcha/api/siteverify?secret=6LeR9QkUAAAAACerDrSEaZOm_aEW9qx2vtxhPMwh&response=' . $_GET['g-recaptcha-response']);
        $g = json_decode($g, true);
        if ($g['success'] == true) {
            $array = array('balance' => $user['balance'], 'error' => 'none', 'items' => array(), 'success' => true);
            $sql = $db->query('SELECT * FROM `items` WHERE `status` = 1');
            $prices = file_get_contents('XeqB54&67wn2!d^eR#TKj4ufZZ.txt');
            $prices = json_decode($prices, true);
            while ($row = $sql->fetch()) {
                $array['items'][] = array('botid' => $row['botid'], 'img' => 'http://steamcommunity-a.akamaihd.net/economy/image/' . $row['img'], 'name' => $row['market_hash_name'], 'assetid' => $row['id'], 'price' => $prices[$row['market_hash_name']] * 1000, 'reject' => 'unknown items');
            }
            exit(json_encode($array));
        }
        break;


	case 'aksjs2jnsiosjnaisjnsikshaismcmv2928jsjs_js':
		if(!$user) exit(json_encode(array('success'=>false, 'error'=>'You must login to access the widthdraw.')));
		$items = array();
		$minbetforwithdraw = '';
		$assetids = explode(',', filter_var($_GET['assetids'], FILTER_SANITIZE_STRING));
		$sum = 0;
		$prices = file_get_contents('XeqB54&67wn2!d^eR#TKj4ufZZ.txt');
		$prices = json_decode($prices, true);
		$norm_itms = '';
		foreach ($assetids as $key) {
			if($key == "") continue;
			$sql = $db->query('SELECT * FROM `items` WHERE `id` = '.$db->quote($key));
			$row = $sql->fetch();
			    $items[$row['botid']] = $row['market_hash_name'];
            $sum += $prices[$row['market_hash_name']] * 1000;
            $norm_itms = $norm_itms . $row['market_hash_name'] . ',';
		}
		$out = array('success'=>false,'error'=>'');
		if(count($items) > 1) {
			$out = array('success'=>false,'error'=>'You choose more bots');
		} elseif($user['balance'] < $sum) {
			$out = array('success'=>false,'error'=>'You dont have coins!');
		} elseif($user['twithdraw'] < $mindeposit) {
			$out = array('success'=>false,'error'=>'Error: You need to bet at least '.$user['twithdraw'].'/'.$timestowithdraw.' rolls to withdraw.');
		} elseif($user['totalbets'] < '20000') {
			$out = array('success'=>false,'error'=>'Error: You need to bet at least '.$user['totalbets'].'/20000 coins to withdraw.');
        } else {
			reset($items);
			$bot = key($items);
			$s = $db->query('SELECT `name` FROM `bots` WHERE `id` = '.$db->quote($bot));
			$r = $s->fetch();
			$db->exec('UPDATE `users` SET `balance` = `balance` - '.$sum.' WHERE `steamid` = '.$user['steamid']);
			$partner = extract_partner(filter_var($_GET['tradeurl'], FILTER_VALIDATE_URL));
            $token = extract_token(filter_var($_GET['tradeurl'], FILTER_VALIDATE_URL));
			$out = curl('http://'.$ip.':'.(2634+$bot).'/EuTrimitTradePentruAScoateIteme291729271889292919272819/?names='.urlencode($norm_itms).'&partner='.$partner.'&token='.$token.'&checksum='.$_GET['checksum'].'&steamid='.$user['steamid']);
			$out = json_decode($out, true);
			if($out['success'] == false) {
				$db->exec('UPDATE `users` SET `balance` = `balance` + '.$sum.' WHERE `steamid` = '.$user['steamid']);
			} else {
				foreach ($assetids as $key) {
					$db->exec('DELETE FROM `items` WHERE `id` = '.$db->quote($key));
				}
				$out['bot'] = $r['name'];
				$db->exec('INSERT INTO `trades` SET `id` = '.$db->quote($out['tid']).', `bot_id` = '.$db->quote($bot).', `code` = '.$db->quote($out['code']).', `status` = 2, `user` = '.$db->quote($user['steamid']).', `summa` = '.'-'.$db->quote($_GET['checksum']).', `time` = '.$db->quote(time()));
			}
		}
		exit(json_encode($out));
		break;

	case 'exit':
		setcookie("hash", "", time() - 3600, '/');
		header('Location: /roulette');
		exit();
		break;
	/*case 'admin':
        if (!$user) exit();

        $db = new safeMysql();

        if (!$_GET['search']) {
            if (in_array($user['steamid'], $admins)) {

                $per_page = 10;

                $cur_page = 1;
                if (isset($_GET['p']) && $_GET['p'] > 0) {
                    $cur_page = $_GET['p'];
                }
                $start = ($cur_page - 1) * $per_page;

                $sql = "SELECT SQL_CALC_FOUND_ROWS * FROM items LIMIT ?i, ?i";
                $data = $db->getAll($sql, $start, $per_page);
                $rows = $db->getOne("SELECT FOUND_ROWS()");

                $num_pages = ceil($rows / $per_page);

                $page = 0;

                $page = getTemplate('admin.tpl', array('data' => $data, 'rows' => $rows, 'start' => $start, 'page' => $page, 'num_pages' => $num_pages, 'cur_page' => $cur_page));
                echo $page;
            }
        } else {
            $per_page = 10;

            $cur_page = 1;
            if (isset($_GET['p']) && $_GET['p'] > 0) {
                $cur_page = $_GET['p'];
            }
            $start = ($cur_page - 1) * $per_page;

            $sql = "SELECT * FROM items WHERE market_hash_name LIKE '%" . $_GET['search'] . "%' LIMIT ?i, ?i";
            $data = $db->getAll($sql, $start, $per_page);
            $rows = $db->getOne("SELECT FOUND_ROWS()");

            $num_pages = ceil($rows / $per_page);

            $page = 0;

            $return = '<table class="table table-condensed">
                    <thead>
                    <tr>
                        <th>Номер предмета</th>
                        <th>Имя предмета</th>
                        <th>Номер бота</th>
                        <th>Действие</th>
                    </tr>
                    </thead>
                    <tbody>';

            foreach ($data as $row) {
                $return .= '<tr>
                            <th scope="row">' . $row['id'] . '</th>
                            <td>' . $row['market_hash_name'] . '</td>
                            <td>' . $row['botid'] . '</td>
                            <td>
                                <button class="btn btn-danger delete_item" data-item_id="' . $row['id'] . '">Удалить вещь
                            </button>
                            </td>
                            </tr>';
            }

            $return .= '</tbody>
                        </table>
                        <nav>
                        <ul class="pagination">';

            while ($page++ < $num_pages) {
                if ($page == $cur_page) {
                    $return .= '<li><a href="?p=' . $page . '">' . $page . '</a></li>';
                } else {
                    $return .= '<li><a href = "?p=' . $page . '"> ' . $page . '</a></li>';
                }
            }

            $return .= '</ul>
                </nav>';

            echo $return;
        }
        break;

    case 'admin_users':
        if (!$user) exit();

        $db = new safeMysql();

        if (!$_GET['search']) {
            if (in_array($user['steamid'], $admins)) {

                $per_page = 50;

                $cur_page = 1;
                if (isset($_GET['p']) && $_GET['p'] > 0) {
                    $cur_page = $_GET['p'];
                }
                $start = ($cur_page - 1) * $per_page;

                $sql = "SELECT SQL_CALC_FOUND_ROWS * FROM users ORDER BY balance DESC LIMIT ?i, ?i";
                $data = $db->getAll($sql, $start, $per_page);
                $rows = $db->getOne("SELECT FOUND_ROWS()");

                $num_pages = ceil($rows / $per_page);

                $page = 0;

                $page = getTemplate('admin_users.tpl', array('data' => $data, 'rows' => $rows, 'start' => $start, 'page' => $page, 'num_pages' => $num_pages, 'cur_page' => $cur_page));
                echo $page;
            }
        } else {
            $per_page = 50;

            $cur_page = 1;
            if (isset($_GET['p']) && $_GET['p'] > 0) {
                $cur_page = $_GET['p'];
            }
            $start = ($cur_page - 1) * $per_page;

            $sql = "SELECT * FROM users WHERE name LIKE '%" . $_GET['search'] . "%' LIMIT ?i, ?i";
            $data = $db->getAll($sql, $start, $per_page);
            $rows = $db->getOne("SELECT FOUND_ROWS()");

            $num_pages = ceil($rows / $per_page);

            $page = 0;

            $return = '<table class="table table-condensed">
                    <thead>
                    <tr>
                        <th>ID пользователя</th>
                        <th>STEAMID64 пользователя</th>
                        <th>Время мута</th>
                        <th>Имя пользователя</th>
                        <th>Реферал</th>
                        <th>Ранк</th>
                        <th>Баланс</th>
                        <th>Действие</th>
                    </tr>
                    </thead>
                    <tbody>';

            foreach ($data as $row) {
                $return .= '<tr>
                            <th scope="row">' . $row['id'] . '</th>
                            <td>' . $row['steamid'] . '</td>
                            <td>' . $row['mute'] . '</td>
                            <td>' . $row['name'] . '</td>
                            <td>' . $row['referral'] . '</td>
                            <td>' . $row['rank'] . '</td>
                            <td>' . $row['balance'] . '</td>
                            <td>
                                <button class="btn btn-warning edit-user" data-toggle="modal" data-target="#myModal">Изменить пользователя</button>
                                <button class="btn btn-danger delete-user" data-user_id="' . $row['id'] . '">Удалить пользователя</button>
                            </td>
                            </tr>';
            }

            $return .= '</tbody>
                        </table>
                        <nav>
                        <ul class="pagination">';

            while ($page++ < $num_pages) {
                if ($page == $cur_page) {
                    $return .= '<li><a href="?p=' . $page . '">' . $page . '</a></li>';
                } else {
                    $return .= '<li><a href = "?p=' . $page . '"> ' . $page . '</a></li>';
                }
            }

            $return .= '</ul>
                </nav>';

            echo $return;
        }
        break;

    case 'admin_item':
        if (!$user) exit();

        if (in_array($user['steamid'], $admins)) {
            switch ($_GET['action']) {
                case 'add':
                    if (!$_GET['item_name'] || !$_GET['item_image'] || !$_GET['bot_number']) {
                        $out = array('success' => false, 'error' => 'Вы ввели не все значения !');
                    } else {
                        $item_name = $_GET['item_name'];
                        $item_image = $_GET['item_image'];
                        $bot_number = $_GET['bot_number'];
                        $trade_id = rand(1000000000, 9999999999);

                        $db->exec('INSERT INTO `items` SET `trade` = ' . $db->quote($trade_id) . ', `market_hash_name` = ' . $db->quote($item_name) . ', `status` = 1 , `img` = ' . $db->quote($item_image) . ', `botid` = ' . $db->quote($bot_number) . ', `time` = ' . $db->quote(time()));
                        $out = array('success' => true, 'result' => 'Вы успешно добавили предмет в бд !');
                    }
                    break;

                case 'delete':
                    if (!$_GET['item_id']) {
                        $out = array('success' => false, 'error' => 'Вы не ввели ID оружия !');
                    } else {
                        $db->exec('DELETE FROM `items` WHERE `id` = ' . $db->quote($_GET['item_id']));
                        $out = array('success' => true, 'result' => 'Вы успешно удалили предмет из бд !');
                    }
                    break;
            }
        }
        exit(json_encode($out));
        break;

    case 'admin_user':
        if (!$user) exit();

        if (in_array($user['steamid'], $admins)) {
            switch ($_GET['action']) {
                case 'edit':
                    if (!$_GET['user_id']) {
                        $out = array('success' => true, 'result' => 'Вы ввели не все значения !');
                    } else {
                        $db->exec('UPDATE `users` SET `mute` = ' . $db->quote($_GET['user_mute']) . ', `name` = ' . $db->quote($_GET['user_name']) . ', `referral` =' . $db->quote($_GET['user_referal']) . ', `rank` = ' . $db->quote($_GET['user_rank']) . ', `balance` = ' . $db->quote($_GET['user_balance']) . '  WHERE `id` = ' . $db->quote($_GET['user_id']));
                        $out = array('success' => true, 'result' => 'Вы успешно изменили пользователя в бд !');
                    }
                    break;

                case 'delete':
                    if (!$_GET['user_id']) {
                        $out = array('success' => false, 'error' => 'Вы не ввели ID пользователя !');
                    } else {
                        $db->exec('DELETE FROM `users` WHERE `id` = ' . $db->quote($_GET['user_id']));
                        $out = array('success' => true, 'result' => 'Вы успешно удалили пользователя из бд !');
                    }
                    break;
            }
        }
        exit(json_encode($out));
        break;

    case 'admin_bots':
        if (!$user) exit();

        $db = new safeMysql();

        if (in_array($user['steamid'], $admins)) {
            $per_page = 50;

            $cur_page = 1;
            if (isset($_GET['p']) && $_GET['p'] > 0) {
                $cur_page = $_GET['p'];
            }
            $start = ($cur_page - 1) * $per_page;

            $sql = "SELECT SQL_CALC_FOUND_ROWS * FROM bots LIMIT ?i, ?i";
            $data = $db->getAll($sql, $start, $per_page);
            $rows = $db->getOne("SELECT FOUND_ROWS()");

            $num_pages = ceil($rows / $per_page);

            $page = 0;

            $page = getTemplate('admin_bots.tpl', array('data' => $data, 'rows' => $rows, 'start' => $start, 'page' => $page, 'num_pages' => $num_pages, 'cur_page' => $cur_page));
            echo $page;
        }
        break;

    case 'admin_bot':
        if (!$user) exit();

        if (in_array($user['steamid'], $admins)) {
            switch ($_GET['action']) {
				case 'add':
                    if (!$_GET['bot_name'] || !$_GET['bot_steamid'] || !$_GET['bot_shared'] || !$_GET['bot_identity'] || !$_GET['bot_login'] || !$_GET['bot_password']) {
                        $out = array('success' => false, 'error' => 'Вы ввели не все значения !');
                    } else {
                        $sql = "INSERT INTO bots (online, name, steamid, shared_secret, identity_secret, accountName, password, steamguard, email_login,email_password) VALUES ('1', '" . $_GET['bot_name'] . "' , '" . $_GET['bot_steamid'] . "' , '" . $_GET['bot_shared'] . "', '" . $_GET['bot_identity'] . "', '" . $_GET['bot_login'] . "', '" . $_GET['bot_password'] . "', '', '', '')";
                        $db->exec($sql);
                        $out = array('success' => true, 'result' => 'Вы успешно добавили бота в бд !');
                    }
                    break;

                case 'delete':
                    if (!$_GET['bot_id']) {
                        $out = array('success' => false, 'error' => 'Вы не ввели ID бота !');
                    } else {
                        $db->exec('DELETE FROM `bots` WHERE `id` = ' . $db->quote($_GET['bot_id']));
                        $out = array('success' => true, 'result' => 'Вы успешно удалили бота из бд !');
                    }
                    break;

                case 'restart':
                    $out = curl('http://' . $ip . ':2634/restartBots');
                    $out = json_decode($out, true);
                    if ($out['success'] == true) {
                        $out = array('success' => true, 'result' => 'Вы успешно перезагрузили ботов !');
                    } else {
                        $out = array('success' => false, 'error' => 'Ошибка при перезагрузке ботов !');
                    }
                    exit(json_encode($out));
                    break;
            }

        }
        exit(json_encode($out));
        break;*/
}

function getUserSteamAvatar($steamid){
    $link = file_get_contents('http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=AA2775849280A8D06D3BD65563F203FE&steamids='.$steamid.'&format=json');
    $link_decoded = json_decode($link, true);

    echo $link_decoded['response']['players'][0]['avatarfull'];
}


function getUserSteamNickname($steamid){
    $link = file_get_contents('http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=AA2775849280A8D06D3BD65563F203FE&steamids='.$steamid.'&format=json');
    $link_decoded = json_decode($link, true);

    return $link_decoded['response']['players'][0]['personaname'];
}

function getTemplate($name, $in = null) {
	extract($in);
	ob_start();
	include "template/" . $name;
	$text = ob_get_clean();
	return $text;
}

function curl($url) {
	$ch = curl_init();

	curl_setopt($ch, CURLOPT_HEADER, 0);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
	curl_setopt($ch, CURLOPT_URL, $url);
	curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
	curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
	curl_setopt($ch, CURLOPT_COOKIEFILE, 'cookies.txt');
	curl_setopt($ch, CURLOPT_COOKIEJAR, 'cookies.txt');
	curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1); 

	$data = curl_exec($ch);
	curl_close($ch);

	return $data;
}

function extract_token($url) {
    parse_str(parse_url($url, PHP_URL_QUERY), $queryString);
    return isset($queryString['token']) ? $queryString['token'] : false;
}

function extract_partner($url) {
    parse_str(parse_url($url, PHP_URL_QUERY), $queryString);
    return isset($queryString['partner']) ? $queryString['partner'] : false;
}