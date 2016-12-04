<html lang="en"><head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<title>403 Forbidden</title>
		<link href="/template/css/bootstrap.min.new.css" rel="stylesheet">
<link href="/template/css/font-awesome.min.css" rel="stylesheet">
<link href="/template/css/dataTables.bootstrap.min.css" rel="stylesheet">

<link href="/template/css/mineNew.css?v=5" rel="stylesheet">
<link href="/template/css/hover.css" rel="stylesheet">
<link id="style" href="" rel="stylesheet">

<link rel="shortcut icon" href="img/favicon.ico">

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
	<div class="container" style="width:100%;">
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
				<li class="hvr-underline-from-left" style="margin-left:5px"><a href="/"><i class="fa fa-home"></i> Home</a></li>
				<li class="hvr-underline-from-left"><a href="/deposit"><i class="fa fa-level-down"></i>&nbsp;Deposit</a></li>
				<li class="hvr-underline-from-left"><a href="/withdraw"><i class="fa fa-level-up"></i>&nbsp;Withdraw</a></li>
				<li class="hvr-underline-from-left"><a href="/rolls"><i class="fa fa-area-chart"></i>&nbsp;Provably Fair</a></li>
				<li class="hvr-underline-from-left"><a href="/affiliates"><i class="fa fa-users"></i>&nbsp;Affiliates</a></li>
				<li class="hvr-underline-from-left"><a href="/giveaway"><i class="fa fa-gift"></i>&nbsp;Giveaway</a></li>
			</ul>
			<? if($user): ?>
				<ul class="nav navbar-nav navbar-right">
					<li class="dropdown">
						<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false" style="padding-top:0px;padding-bottom:0px;line-height:50px"> <img class="rounded" src="<?=$user['avatar']?>"> <b><?=$user['name']?></b> <span class="caret"></span></a>
						<ul class="dropdown-menu" role="menu">
							<!-- <li><a href="#" data-toggle="modal" data-target="#pointsModal"><i class="fa fa-user fa-fw"></i> Profile</a></li> -->
							<li><a href="#" data-toggle="modal" data-target="#promoModal"><i class="fa fa-ticket fa-fw"></i> Redeem</a></li> 
							<li><a href="/bets"><i class="fa fa-line-chart fa-fw"></i> Bet History</a></li>
							<li><a href="/offers"><i class="fa fa-history fa-fw"></i> Trade history</a></li>
							<li><a href="/transfers"><i class="fa fa-exchange fa-fw"></i> Transfer history</a></li>
							<li><a href="#" data-toggle="modal" data-target="#settingsModal"><i class="fa fa-cog fa-fw"></i> Settings</a></li>
							<li><a href="#" data-toggle="modal" data-target="#my64id"><i class="fa fa-question-circle fa-fw"></i> My Steam64Id</a></li>
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
					<label for="exampleInputEmail1">Promo code</label>
					<input type='text' class='form-control' id='promocode' value=''>				</div>				  	
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
				<button type="button" class="btn btn-success" onclick="redeem()">Reedem</button>
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
		url:"/redeem?code="+code,
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

</script>

		<div id="mainpage" class="col-xs-9">
			<div class="well text-center" style="padding:5px;margin-bottom:5px">
				<div style="margin: 20px 0px;">
				</div>
				<div class="form-group">
					<h1 style="color:red">Forbidden</h1>
					<h2>You don't have permission to access this folder/file.</h2>
				</div>
			</div>
		</div>
		
		
		<ul id="contextMenu" class="dropdown-menu" role="menu" style="display:none">
				<li><a tabindex="-1" href="#" data-act="0">Username</a></li>
			    <li><a tabindex="-1" href="#" data-act="1">Mute player</a></li>
			    <li><a tabindex="-1" href="#" data-act="2">Kick player</a></li>
			    <li><a tabindex="-1" href="#" data-act="3">Send coins</a></li>
			    <li><a tabindex="-1" href="#" data-act="4">Ignore</a></li>
			</ul>	


	<div class="col-xs-3">
		<div id="pullout">
			<div id="tab1" class="tab-group" style="height: 515px;">
				<div class="dropdown" style="margin: -10px; font-family: 'Ubuntu-Medium'; font-size: 13px; padding: 20px; padding-bottom: 10px; text-align: center;">
						<span class="lang-select">MAIN ROOM </span>
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
										<img data-smile="deIlluminati" src="/template/img/twitch/deIlluminati.png">
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
		<div class="panel panel-default">
			<div class="panel-body" style="margin-top: 10px;">
				<div><span class="settings-header" align="center">THEME</span></div>

				<a href="#" id="light" style="width: 27%" class="settings-header"><div class="template" style="background-color: #f1f1f1;">LIGHT</div></a>
				<a href="#" id="dark" style="width: 1%" class="settings-header"><div class="template" style="background-color: #272727; ">DARK</div></a>

			</div>
		</div>
	</div>
		
		
<footer class="well footer">
	<div class="">
		<div class="pull-left" style="overflow:hidden">
			<a href="https://twitter.com/csgocrowngg" target="_blank"><img class="rounded" src="/template/img/social/twitter_icon.png"></a>
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







