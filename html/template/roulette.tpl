<html lang="en"><head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<title>CSGOCROWN - Play</title>
		<link href="/template/css/bootstrap.min.new.css" rel="stylesheet">
<link href="/template/css/font-awesome.min.css" rel="stylesheet">
<link href="/template/css/dataTables.bootstrap.min.css" rel="stylesheet">

<link href="/template/css/mineNew.css?v=5" rel="stylesheet">
<link href="/template/css/hover.css" rel="stylesheet">
<link id="style" href="/template/css/black.css" rel="stylesheet">

<!-- required snowstorm JS, default behaviour
<script src="/template/js/snowstorm-min.js"></script>-->

<!-- now, we'll customize the snowStorm object
<script>
snowStorm.snowColor = '#99ccff';   // blue-ish snow!?
snowStorm.flakesMaxActive = 96;    // show more snow on screen at once
snowStorm.useTwinkleEffect = true; // let the snow flicker in and out of view
snowStorm.excludeMobile = false;
snowStorm.followMouse = false;
</script>-->

<!-- <link href="/template/css/dark.css" rel="stylesheet"> -->

<link rel="shortcut icon" href="/template/img/favicon.ico">

<script src="/template/js/jquery-1.11.1.min.js"></script>
<script src="/template/js/jquery.cookie.js"></script>
<script src="/template/js/socket.io-1.4.5.js"></script>
<script src="/template/js/bootstrap.min.js"></script>
<script src="/template/js/bootbox.min.js"></script>
<script src="/template/js/jquery.dataTables.min.js"></script>
<script src="/template/js/dataTables.bootstrap.js"></script>
<script src="/template/js/tinysort.js"></script>
<script src="/template/js/expanding.js"></script>
<script src="/template/js/theme.js"></script>


<script>
	var SETTINGS = ["confirm","sounds","dongers","hideme"];
	function inlineAlert(x,y){
		$("#inlineAlert").removeClass("alert-success alert-danger alert-warning hidden");
		if(x=="success"){
			$("#inlineAlert").addClass("alert-success").html("<i class='fa fa-check'></i><b> "+y+"</b>");
		}else if(x=="error"){
			$("#inlineAlert").addClass("alert-danger").html("<i class='fa fa-exclamation-triangle'></i> "+y);
		}else if(x=="cross"){
			$("#inlineAlert").addClass("alert-danger").html("<i class='fa fa-times'></i> "+y);
		}else{
			$("#inlineAlert").addClass("alert-warning").html("<b>"+y+" <i class='fa fa-spinner fa-spin'></i></b>");
		}
	}
	function resizeFooter(){
		var f = $('.footer').outerHeight(true);
		var w = $(window).outerHeight(true);
		$('body').css('margin-bottom',f);
	}
	$(window).resize(function(){
		resizeFooter();
	});
	if (!String.prototype.format) {
	  String.prototype.format = function() {
	    var args = arguments;
	    return this.replace(/{(\d+)}/g, function(match, number) { 
	      return typeof args[number] != 'undefined'
	        ? args[number]
	        : match
	      ;
	    });
	  };
	}
	function setCookie(key,value){
		var exp = new Date();
		exp.setTime(exp.getTime()+(365*24*60*60*1000));
		document.cookie = key+"="+value+"; expires="+exp.toUTCString();
	}
	function getCookie(key){
		var patt = new RegExp(key+"=([^;]*)");
		var matches = patt.exec(document.cookie);
		if(matches){
			return matches[1];
		}
		return "";
	}
	
	function formatNum(x){
		if(Math.abs(x)>=10000){
			return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
		}
		return x;
	}
	
	function resizeFull() {
				
		if($('.row > div').eq(0).hasClass('col-xs-3')) {
			$('.row > div').eq(0).removeClass('col-xs-3').addClass('col-xs-1');
			$('.row > div').eq(1).removeClass('col-xs-9').addClass('col-xs-11');
			$('#pullout').hide();
			$('.settings-header').css('display', 'block');
			$('#settings-head').hide();
			$('.resizeFull').removeClass('fa-arrow-circle-right').addClass('fa-arrow-circle-left');
		} else {
			$('.row > div').eq(0).removeClass('col-xs-1').addClass('col-xs-3');
			$('.row > div').eq(1).removeClass('col-xs-11').addClass('col-xs-9');
			$('#pullout').show();
			$('#settings-head').show();
			$('.settings-header').css('display', 'inline-block');
			$('.resizeFull').removeClass('fa-arrow-circle-left').addClass('fa-arrow-circle-right');
		}
	}
	
	$(document).ready(function(){
		resizeFooter();
		for(var i=0;i<SETTINGS.length;i++){
			var v = getCookie("settings_"+SETTINGS[i]);
			if(v=="true"){
				$("#settings_"+SETTINGS[i]).prop("checked",true);	
			}else if(v=="false"){
				$("#settings_"+SETTINGS[i]).prop("checked",false);	
			}			
		}
		//Read cookie for Agreement here <<
		if(getCookie("agreement") == 0) $('#Agreement').modal('show');
	});
</script>
		<style>
		.navbar{
			margin-bottom: 0px;
		}
		.progress-bar{
			transition:         none !important;
			-webkit-transition: none !important;
			-moz-transition:    none !important;
			-o-transition:      none !important;
		}
		#case {

			max-width: 1050px;
			height: 69px;
			background-image: url("/template/img/cases.png");
			background-repeat: no-repeat;
			background-position: 0px 0px;
			position: relative;
			margin:0px auto;

		}	
		</style>
		<script type="text/javascript" src="/template/js/new.js?v=<?=time()?>"></script>	</head>
	<body style="margin-bottom: 62px;">
		<nav class="navbar navbar-default navbar-static-top" role="navigation">
	<div class="container">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
				<span class="sr-only">Toggle navigation</span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
            <a class="navbar-brand" href="/"><div id="logo" class="logo"></div></a>
		</div>
		<div id="navbar" class="navbar-collapse collapse">
			<ul class="nav navbar-nav">
				<li class="hvr-underline-reveal" style="margin-left:5px"><a href="/"><i class="fa fa-home"></i> Home</a></li>
				<li class="hvr-underline-reveal"><a href="/deposit"><i class="fa fa-level-down"></i>&nbsp;Deposit</a></li>
				<li class="hvr-underline-reveal"><a href="/withdraw"><i class="fa fa-level-up"></i>&nbsp;Withdraw</a></li>
				<li class="hvr-underline-reveal"><a href="/rolls"><i class="fa fa-area-chart"></i>&nbsp;Provably Fair</a></li>
				<li class="hvr-underline-reveal"><a href="#" data-toggle="modal" data-target="#promoModal"><i class="fa fa-ticket"></i>&nbsp;Redeem Code</a></li>
				<li class="hvr-underline-reveal"><a href="/giveaway"><i class="fa fa-gift"></i>&nbsp;Giveaway</a></li>
			</ul>
			<? if($user): ?>
				<ul class="nav navbar-nav navbar-right">
					<li class="dropdown">
						<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false" style="padding-top:0px;padding-bottom:0px;line-height:50px"> <img class="rounded" src="<?=$user['avatar']?>"> <b><?=$user['name']?></b> <span class="caret"></span></a>
						<ul class="dropdown-menu" role="menu">
							<li><a href="#" data-toggle="modal" data-target="#promoModal"><i class="fa fa-ticket fa-fw"></i> Redeem Code</a></li> 
							<li><a href="/bets"><i class="fa fa-line-chart fa-fw"></i> Bet History</a></li>
							<li><a href="/offers"><i class="fa fa-history fa-fw"></i> Trade history</a></li>
							<li><a href="/transfers"><i class="fa fa-exchange fa-fw"></i> Transfer history</a></li>
							<li><a href="#" data-toggle="modal" data-target="#settingsModal"><i class="fa fa-cog fa-fw"></i> Settings</a></li>
							<li class="divider"></li>
							<? if(($user['rank'] == "99") OR ($user['rank'] == "100") OR ($user['rank'] == "4")): ?>
							<li><a href="/adminsupport"><i class="fa fa-ticket"></i>Support Tickets&nbsp;</a></li>
							<li class="divider"></li>
							<? endif; ?>
							<li><a href="/exit"><i class="fa fa-power-off fa-fw"></i> Logout</a></li>
						</ul>
					</li>
				</ul>

			<? else: ?>
			<ul class="nav navbar-nav navbar-right">
				<a href="/login"><img style="margin-top:3px;" src="/template/img/green.png"></a>
			</ul>

			<? endif; ?>
		</div>
	</div>
</nav>

<div class="modal fade" id="my64id">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h4 class="modal-title"><b>My Steam64Id</b></h4>
			</div>
			<div class="modal-body">
				<b><?=($user)?$user['steamid']:''?></b>			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="settingsModal">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h4 class="modal-title"><b>Settings</b></h4>
			</div>
			<div class="modal-body">
				<form>	  			        	
								  
				  	<div class="checkbox">
				    	<label>
				      		<input type="checkbox" id="settings_confirm" checked>
				      		<strong>Confirm all bets over 10,000 coins</strong>
				    	</label>
				  	</div>
				  	<div class="checkbox">
				    	<label>
				      		<input type="checkbox" id="settings_sounds" checked>
				      		<strong>Enable sounds</strong>
				    	</label>
				  	</div>
				  	<div class="checkbox">
				    	<label>
				      		<input type="checkbox" id="settings_dongers">
				      		<strong>Display balance in dollar($)</strong>
				    	</label>
				  	</div>
				  	<div class="checkbox">
				    	<label>
				      		<input type="checkbox" id="settings_hideme">
				      		<strong>Hide my profile link in chat</strong>
				    	</label>
				  	</div>
				  	
				</form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
				<button type="button" class="btn btn-success" onclick="saveSettings()">Save changes</button>
			</div>
		</div>
	</div>
</div>
<div class="modal fade" id="promoModal">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h4 class="modal-title"><b>Redeem Promo Code to get 500 coins for free!</b></h4>
			</div>
			<div class="modal-body">
				
				<div class="form-group">
					<label for="promocode">Promo Code</label>
					<input type='text' class='form-control' id='promocode' value=''>
					<button type="button" class="btn btn-success" onclick="redeem()">Reedem Promo Code</button>
				</div>
				<div class="form-group">
					<label for="promocode">Bonus Code</label>
					<input type='text' class='form-control' id='bonuscode' value=''>
					<button type="button" class="btn btn-success" onclick="redeemBonus()">Reedem Bonus Code</button>
				</div>					
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
			</div>
		</div>
	</div>
</div>
<div class="modal fade" id="chatRules">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h4 class="modal-title"><b>Chat Rules</b></h4>
			</div>
			<div class="modal-body" style="font-size:24px">				  
				<ol>
					<li>No Links</li>
					<li>No Spamming</li>
					<li>No Begging for Coins</li>
					<li>No Posting Promo Codes</li>
					<li>No Promo Codes in Profile Name</li>
					</ol>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-success btn-block" data-dismiss="modal">Got it!</button>
			</div>
		</div>
	</div>
</div>
<? if($user): ?>
<div class="modal fade" id="agreement">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title"><b style="color: red;">Agreement on the use of the site</b></h4>
			</div>
			<div class="modal-body"><p>Dear users, continuing to use our site ("CSGOCROWN.GG") you agree to the <a target="_blank" href="/tos">user agreement</a> and acknowledge that you are 18 years or more.</p><p>If you do not agree with it and/or you are under 18, then immediately withdraw all the money from your account and do not continue the game, otherwise your account may be restricted/removed as a violation of the <a target="_blank" href="/tos">user agreement</a>.</p></div>
			<div class="modal-footer">
				<button type="button" class="btn btn-danger btn-block" data-dismiss="modal" onclick="acceptAgreement();">I accept and confirm!</button>
			</div>
		</div>
	</div>
</div>
<? endif; ?>
<script>
function saveSettings(){
	for(var i=0;i<SETTINGS.length;i++){
		setCookie("settings_"+SETTINGS[i],$("#settings_"+SETTINGS[i]).is(":checked"));
	}
	$("#settingsModal").modal("hide");
	if($("#settings_dongers").is(":checked")){
		$("#balance").html("please reload");
	}else{
		$("#balance").html("please reload");
	}
}
function redeem(){
	var code = $("#promocode").val();
	$.ajax({
		url:"/promo?code="+code,
		success:function(data){		
			try{
				data = JSON.parse(data);
				console.log(data);
				if(data.success){
					bootbox.alert("Success! You've received "+data.credits+" credits.");					
				}else{
					bootbox.alert(data.error);
				}
			}catch(err){
				bootbox.alert("Javascript error: "+err);
			}
		},
		error:function(err){
			bootbox.alert("AJAX error: "+err);
		}
	});
}
function redeemBonus(){
	var code = $("#bonuscode").val();
	$.ajax({
		url:"/bonus?code="+code,
		success:function(data){		
			try{
				data = JSON.parse(data);
				console.log(data);
				if(data.success){
					bootbox.alert("Success! You've received "+data.credits+" credits.");					
				}else{
					bootbox.alert(data.error);
				}
			}catch(err){
				bootbox.alert("Javascript error: "+err);
			}
		},
		error:function(err){
			bootbox.alert("AJAX error: "+err);
		}
	});
}
// Sets a cookie for agreement
function acceptAgreement(){
	setCookie("agreement",1);
}


</script>
	
	<!-- Messages -->
		<div id="mainpage" class="col-xs-9">
			<!--<div class="alert alert-success text-center" style="margin-bottom:5px;margin-top:25px">
				<button type="button" class="close" data-dismiss="alert">×</button>
				<b><i class="fa fa-exclamation-circle">
				</i> Join our <a href="http://steamcommunity.com/groups/csgocrowngg" target="_blank">steam group </a>and join giveaways.
				</b>
			</div>-->

			<div class="alert alert-warning text-center" style="margin-bottom:5px">
				<b><i class="fa fa-exclamation-circle">
				</i> The Site is currently in <strong>Beta-Testing Mode.</strong> Use redeem code "CROWN" to get $500 for beta test. After the beta test <strong>ALL USERS WILL BE WIPED.</strong><br />
				Therefore deposits and withdrawal is disabled untill beta is over. Report all bugs/problems by e-mail; csgocrowngg@gmail.com Thanks!
				</b>
			</div>
			
			
    	<!-- Timer -->
		  <div class="well text-center" style="margin-bottom:10px;margin-top:10px; padding: 10px;">	
			<div class="progress text-center" style="height:50px;margin-bottom:5px;margin-top:5px">
				<span id="banner"></span>
				<div class="progress-bar progress-bar-striped progress-bar-danger" id="counter"></div>
			</div>

			<!-- Bets -->
		<div id="case" style="margin-bottom: 5px; background-position: -710.5px 0px;"><div id="pointer"></div></div>
		<div class="well text-center" style="padding:5px;margin-bottom:5px"><div id="past"></div>
			<div style="margin: 20px 0px;">
			</div>
			<div class="form-group">
				<div class="input-btn bet-buttons">
					<span style="font-size: 13px;background-color: #b04a43; padding: 10px 20px; margin-right: 5px; color: #fff; border-radius: 10px;"> 
						<span>Balance: </span>
						<span id="dongers"></span>
						<span id="balance">0</span> <i style="cursor:pointer; margin-left: 5px; padding-bottom: 20px;" class="hvr-icon-spin noselect" id="getbal"></i>
					</span>
					<input type="text" class="form-control input-lg" placeholder="Bet amount..." id="betAmount">
					<button type="button" style="" id="oneplusbutton" class="btn btn-primary betshort hvr-bounce-in" data-action="clear"><i class="fa fa-life-ring fa-spin"></i>Daily Coins!</button></p>
					<button type="button" class="btn btn-danger betshort" data-action="clear">Clear</button>
					<button type="button" class="btn btn-default betshort" data-action="10">+10</button>
					<button type="button" class="btn btn-default betshort" data-action="100">+100</button>
					<button type="button" class="btn btn-default betshort" data-action="1000">+1000</button>
					<button type="button" class="btn btn-default betshort" data-action="half">1/2</button>
					<button type="button" class="btn btn-default betshort" data-action="double">x2</button>
					<button type="button" class="btn btn-primary betshort" data-action="max">Max</button>
				</div>
			</div>
			
				<?
				  // Function returns Steam status (default timeout: 5 seconds)
				  function get_steam_status($steamID64, $timeout = 5) {
					$context = stream_context_create(array('http' => array('timeout' => $timeout)));
					$file = @file_get_contents('http://steamcommunity.com/profiles/' . $steamID64 . '/?xml=1', false, $context);
					$xml = simplexml_load_string($file);
					if (isset($xml->onlineState)) {
					  $online_state = (string)$xml->onlineState;
					  $state_message = ($online_state == 'offline' ? 'Offline' : (string)$xml->stateMessage);
					  return '<span class="label label-success" style="background-color:#2671b8">Steam is Normal</span>';
					} else {
					  // Error loading profile
					  $online_state = 'offline';
					  $state_message = 'Offline';
					  return '<span class="label label-danger" style="background-color:#c9302c">Steam is having problems</span>';
					}
				  }
				  echo get_steam_status('76561197979506695');
				?>
		</div>
			</div>
			
			<div class="row text-center">
			<div class="col-xs-4 betBlock" style="padding-right:0px">
				<div class="panel panel-default bet-panel" id="panel11-7-b">
					<div class="panel-heading">
						<button class="btn btn-danger btn-lg  btn-block betButton" data-lower="1" data-upper="7"><span> 1 to 7</span><span></span></button>
					</div>
				</div>
				<div class="panel panel-default bet-panel" id="panel1-7-m">
					<div class="panel-body" style="padding:0px">
						<div class="my-row">
							<div class="text-center"><span class="mytotal">0</span></div>
						</div>
					</div>
				</div>
				<div class="panel panel-default bet-panel" id="panel1-7-t">
					<div class="panel-body" style="padding:0px" id="panel1-7">
						<div class="total-row">
							<div class="text-center">Total bet: <span class="total">0</span></div>
						</div>
						<ul class="list-group betlist"></ul>
					</div>
				</div>
			</div>
			<div class="col-xs-4 betBlock">
				<div class="panel panel-default bet-panel" id="panel0-0-b">
					<div class="panel-heading">
						<button class="btn btn-success btn-lg  btn-block betButton" data-lower="0" data-upper="0">0</button>
					</div>
				</div>
				<div class="panel panel-default bet-panel" id="panel0-0-m">
					<div class="panel-body" style="padding:0px">
						<div class="my-row">
							<div class="text-center"><span class="mytotal">0</span></div>
						</div>
					</div>
				</div>
				<div class="panel panel-default bet-panel" id="panel0-0-t">
					<div class="panel-body" style="padding:0px" id="panel0-0">
						<div class="total-row">
							<div class="text-center">Total bet: <span class="total">0</span></div>
						</div>
						<ul class="list-group betlist"></ul>
					</div>
				</div>
			</div>
			<div class="col-xs-4 betBlock" style="padding-left:0px">
				<div class="panel panel-default bet-panel" id="panel8-14-b">
					<div class="panel-heading">
						<button class="btn btn-inverse btn-lg  btn-block betButton" data-lower="8" data-upper="14"><span> 8 to 14</span><span></span></button>
					</div>
				</div>
				<div class="panel panel-default bet-panel" id="panel8-14-m">
					<div class="panel-body" style="padding:0px">
						<div class="my-row">
							<div class="text-center"><span class="mytotal">0</span></div>
						</div>
					</div>
				</div>
				<div class="panel panel-default bet-panel" id="panel8-14-t">
					<div class="panel-body" style="padding:0px" id="panel8-14">
						<div class="total-row">
							<div class="text-center">Total bet: <span class="total">0</span></div>
						</div>
						<ul class="list-group betlist"></ul>
					</div>
				</div>
			</div>
		</div>
		</div>
		
		
		<ul id="contextMenu" class="dropdown-menu" role="menu" style="display:none">
				<li><a tabindex="-1" href="#" data-act="0">Username</a></li>
			    <li><a tabindex="-1" href="#" data-act="1">Mute player</a></li>
			    <li><a tabindex="-1" href="#" data-act="2">Kick player</a></li>
				<li><a tabindex="-1" href="#" data-act="3">Delete message</a></li>
			    <li><a tabindex="-1" href="#" data-act="4">Send coins</a></li>
			    <li><a tabindex="-1" href="#" data-act="5">Ignore</a></li>
			</ul>	


			<div class="col-xs-3">
	<div id="pullout">
		<div class="promo"> 
				<a href="/giveaway" target="_blank" class="banner">
					<button type="button" class="close" data-dismiss="alert">×</button>
					<img src="/template/img/banners/giveawayxmas.jpg" alt="Giveaway">
				</a>
		</div>
			
		<div id="tab1" class="tab-group" style="height: 515px;">
			<div class="dropdown" style="margin: -10px; font-family: 'Ubuntu-Medium'; font-size: 13px; padding: 20px; padding-bottom: 10px; text-align: center;">
			<!--	<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="true">-->
					<span class="lang-select">MAIN ROOM </span><!--<span class="caret"></span></a>
				<ul class="dropdown-menu language" role="menu" style="width: 100%; border: 0px; box-shadow: 0 0 0;">
					<li><a onclick="changeLang(1)" href="#">MAIN ROOM </a></li>
					<li><a onclick="changeLang(2)" href="#">PREDICT ROOM </a></li>
					<li><a onclick="changeLang(3)" href="#">MULTI-LANGUAGE ROOM </a></li>
					<li><a onclick="changeLang(4)" href="#">TRADE ROOM </a></li>
				</ul>-->
			</div>
			<div style="width: 106,5%;height: 80px;margin: 10px -10px -80px -10px;"></div>
			<div class="divchat" id="chatArea"></div>
			<form id="chatForm">
				<div style="margin: 5px">
					<div class="input-group" style="margin-bottom: 5px">
						<input type="text" class="form-control" placeholder="Type here to chat..." id="chatMessage" maxlength="200">
						<div class="input-group-btn dropdown">
							<button id="Smiles" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true" type="button" class="btn btn-default dropdown-toggle" aria-label="Smiles">
								<span class="glyphicon fa fa-smile-o fa-lg"></span>
							</button>
							<ul class="dropdown-menu dropdown-menu-right smiles" style="padding: 10px;" aria-labelledby="Smiles">
    							<li>
    								<img data-smile="BibleThump" src="/template/img/twitch/BibleThump.png">
    								<img data-smile="gl" src="/template/img/twitch/gl.png">
									<img data-smile="gg" src="/template/img/twitch/gg.png">
									<img data-smile="ez" src="/template/img/twitch/ez.png">
									<img data-smile="fail" src="/template/img/twitch/fail.png">
    							</li>
    							<li>
    								<img data-smile="Fire" src="/template/img/twitch/Fire.png">
    								<img data-smile="Kappa" src="/template/img/twitch/Kappa.png">
    								<img data-smile="KappaPride" src="/template/img/twitch/KappaPride.png">
    								<img data-smile="KappaRoss" src="/template/img/twitch/KappaRoss.png">
    								<img data-smile="Keepo" src="/template/img/twitch/Keepo.png">
    							</li>
    							<li>
    								<img data-smile="Kreygasm" src="/template/img/twitch/Kreygasm.png">
    								<img data-smile="heart" src="/template/img/twitch/heart.png">
    								<img data-smile="offFire" src="/template/img/twitch/offFire.png">
    								<img data-smile="PJSalt" src="/template/img/twitch/PJSalt.png">
    								<img data-smile="rip" src="/template/img/twitch/rip.png">
    							</li>
    							<li>
    								<img data-smile="FailFish" src="/template/img/twitch/FailFish.png">
    								<img data-smile="PogChamp" src="/template/img/twitch/PogChamp.png">
									<img data-smile="luck" src="/template/img/twitch/luck.png">									
									<img data-smile="deIlluminati" src="/template/img/twitch/deIlluminati.png">
    							</li>
							</ul>
						</div>
					</div>
					<div class="pull-left">
						<span>Users online: <span id="isonline">0</span></span>
					</div>
					<div class="pull-right">
						<a href="#" class="clearChat">Clear chat</a>
					</div>
					<br>
					<div class="checkbox pull-right" style="margin: 0px">
						<label class="noselect"><input type="checkbox" id="scroll"><span>Stop chat</span></label>
					</div>
					<div class="pull-left">
						<a href="#" data-toggle="modal" data-target="#chatRules">Chat rules</a>
					</div>
				</div>
			</form>
		</div>
		<div id="tab2" class="tab-group hidden"></div>
		<div id="tab3" class="tab-group hidden"></div>
		</div>
		<div class="panel panel-default" id="settings-head">
			<div class="panel-body" style="margin-top: 10px;">
				<div><span class="settings-header" align="center">THEME</span></div>

				<a href="#" id="light" style="width: 27%" class="settings-header"><div class="template" style="background-color: #f1f1f1;">LIGHT</div></a>
				<a href="#" id="dark" style="width: 1%" class="settings-header"><div class="template" style="background-color: #272727; ">DARK</div></a>

			</div>
		</div>
		
		<!-- Streamer
		<div class="panel panel-default" class="giveawaymynd">
			<div class="panel-body text-center" style="margin-top: 10px;">
				<span>Youtubers</span>
				<div id="streamoff" style="margin-top: 20px;">All streamers offline!</div>
				<div class="streamers">
			</div>
		</div>-->	
	</div>
</div>
				
<footer class="well footer">
	<div class="">
		<div class="pull-left" style="overflow:hidden">
			<a href="https://twitter.com/csgocrowngg" target="_blank"><img class="rounded" src="/template/img/social/twitter_icon.png"></a>
			<a href="http://facebook.com/csgocrown" target="_blank"><img class="rounded" src="/template/img/social/facebook_icon.png"></a>
			<a href="http://steamcommunity.com/groups/csgocrowngg" target="_blank"><img class="rounded" src="/template/img/social/steam_icon.png"></a>
		</div>
		<div class="pull-right" style="overflow:hidden;">
			<a href="http://csgo.steamanalyst.com/" target="_blank"><img class="" src="/template/img/social/sa.gif"></a>
		</div>
		<ul class="list-inline" style="display:inline-block;margin-top:10px">
			<li>Copyright © 2016, CSGOCROWN.GG  - All rights reserved.</li>
			<li><a href="/tos">Terms of Service</a></li>
			<li><a href="/faq">FAQ</a></li>
			<li><a href="/support">Support</a></li>
			<li><a href="http://steampowered.com" target="_target">Powered by Steam</a></li>
		</ul>
	</div>	
</footer>		
</body>
</html>