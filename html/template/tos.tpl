
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<title>CSGOCROWN - ToS</title>
		<link href="/template/css/bootstrap.min.new.css" rel="stylesheet">
		<link href="/template/css/font-awesome.min.css" rel="stylesheet">
		<link href="/template/css/dataTables.bootstrap.min.css" rel="stylesheet">

		<link href="/template/css/mineNew.css?v=5" rel="stylesheet">

		<link id="style" href="" rel="stylesheet">

		<link rel="shortcut icon" href="favicon.ico">

		<script src="/template/js/jquery-1.11.1.min.js"></script>
		<script src="/template/js/jquery.cookie.js"></script>
		<script src="/template/js/bootstrap.min.js"></script>
		<script src="/template/js/bootbox.min.js"></script>
		<script src="/template/js/jquery.dataTables.min.js"></script>
		<script src="/template/js/dataTables.bootstrap.js"></script>
		<script src="/template/js/tinysort.js"></script>
		<script src="/template/js/expanding.js"></script>
		<script src="/template/js/theme.js"></script>
<style>

</style>
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
		
		</style>
		<script type="text/javascript">

			
		</script>	
	</head>
	<body>
		<nav class="navbar navbar-default navbar-static-top" role="navigation">
	<div class="container">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
				<span class="sr-only">Toggle navigation</span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<!-- <a class="navbar-brand" style="padding-top:0px;padding-bottom:0px;padding-right:0px" href="./"><img alt="CSGO.mk" height="34" style="margin-top:8px;margin-bottom:8px;margin-right:5px" src="/template/img/just.png"></a> -->
            <a class="navbar-brand" href="/"><div id="logo" class="logo"></div></a>
		</div>
		<div id="navbar" class="navbar-collapse collapse">
			<ul class="nav navbar-nav">
				<li class="hvr-underline-from-left" style="margin-left:5px"><a href="/"><i class="fa fa-home"></i> Home</a></li>
				<li class=""><a href="/deposit"><i class="fa fa-level-down"></i>&nbsp;Deposit</a></li>
				<li class=""><a href="/withdraw"><i class="fa fa-level-up"></i>&nbsp;Withdraw</a></li>
				<li class="hvr-underline-from-left"><a href="/rolls"><i class="fa fa-area-chart"></i>&nbsp;Provably Fair</a></li>
				<li class="hvr-underline-from-left"><a href="/affiliates"><i class="fa fa-users"></i>&nbsp;Affiliates</a></li>
				<li class=""><a href="/giveaway"><i class="fa fa-gift"></i>&nbsp;Giveaway</a></li>
			</ul>	
			<? if($user): ?>
				<ul class="nav navbar-nav navbar-right">
						<!-- <li><a href="#"><i class="fa fa-gear fa-fw"></i> Settings</a></li> -->
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
				      		<strong>Display in $ amounts</strong>
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
				<button type="button" class="btn btn-primary betshort" onclick="saveSettings()">Save changes</button>
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
		<div class="container" style="margin-bottom: 10%;"><h3 class="text-center">CSGOCROWN Terms of Service</h3>
		
		<h3>Terms of Service</h3>
		<h4>By Using CSGOCROWN.GG, you acknowledge and accept the following Terms of Service in full and without reservation, you are agreeing to our Terms of Service and you are responsible for compliance with any applicable laws in your jurisdiction these Terms of Service govern your use of CSGOCROWN.GG.<br><br><i>You must be age 18 or older to play on CSGOCROWN.</i></h4>
		
		<h3>Ownership</h3>		
		<p>All materials on this website are intellectual property of CSGOCROWN and you may not use any of the content seen here for commercial use without permission. Exclusive rights for Counter Strike: Global Offensive and its associated virtual items belong to Steam and the Valve Corporation.</p>
		
		<h3>Acceptable Use</h3>
		<p>You must not use CSGOCROWN in any way that causes, or may cause, damage to the webite or impairment of the availability or accessibility of CSGOCROWN or in any way which in unlawful, illegal, fraudulent or harmful. Do not use CSGOCROWN.GG, as a source for item exchanging to gain benefits from trading items that are in different price ranges compared to steam and our site.</p>
		
		<h3>Item Values</h3>
		<p>You are participating in games that allow you to deposit and receive intangible items. We display a value in coins to add the effect that these items have no physical value. These coins values are based on the CSGOAnalyst database. These values are subject to change without notice. Patterns on items are not taken into account. By using CSGOCROWN you are accepting our item values and there will be no refund in case of a value issue.</p>
		
		<h3>Bans, Timeouts & Conduct</h3>
		<p>CSGOCROWN reserves the right to remove any user from our website with out and for any reason. Anyone attempting to scam other users maybe permenantly banned from using CSGOCROWN. Players are asked to remain respectful at all times. Excessive spam, harassment, staff impersonation, solicitation, and defamation are strictly forbidden. Website advertisement, particularity of competing services, is not allowed.</p>
		
		<h3>Maximum Bets</h3>
		<p>Maximum bets are adjusted manually to maintain site solvency. The use of multiple accounts to bypass the maximum bet is strictly forbidden. A 1 hour warning will precede any decrease to the maximum bet. An increase to the maximum bet may occur at any time.</p>
		
		<h3>Privacy Policy</h3>
		<p>Steam profiles are used for identification purposes across the site. By using our service you acknowledge that your Steam profile, persona name, and avatar may be shared with other CSGOCROWN users. CSGOCROWN will never ask for, collect, or share the personal information of any of our users.</p>
		
		<h3>Limitations of Liability</h3>
		<p>CSGOCROWN is not responsible for trade/account bans that may occur as a resulting of accepting items from our bots. CSGOCROWN does not refund any items lost on the site. By agreeing to the Terms of Service you are playing on at your own risk. If any of our bots are banned and or your coins are lost due to a bug, your coins on the site are safe and you will be refunded.</p>
		<br>
		<h4><i>CSGOCROWN.GG is not affiliated with Steam or the Valve Corporation.</i></h4></div>
		
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