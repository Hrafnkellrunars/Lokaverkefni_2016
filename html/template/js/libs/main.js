var circle,bets=100500,timeleft=120,ms=1000;
var audioElement = document.createElement('audio');
audioElement.setAttribute('src', 'audio/audio.mp3');
var audioElement2 = document.createElement('audio');
audioElement2.setAttribute('src', 'audio/msg.mp3');
var audioElement3 = document.createElement('audio');
audioElement3.setAttribute('src', 'audio/open.wav');
var ls=0;
var roulet=0;
var clos=0;
var timerinterval;

function setCookie(c_name,value,exdays){
var exdate=new Date();
exdate.setDate(exdate.getDate() + exdays);
var c_value=escape(value) + ((exdays==null) ? "" : "; expires="+exdate.toUTCString());
document.cookie = c_name+"="+c_value+"; path=/";
}

function muteC(){
    if(mute==1){
        mute = 0;
		console.log("All sounds unmuted!");
        $("#mute").attr("src","/img/mute.png");
        $("#mute").attr("title","Mute");
        setCookie("muted",mute,1);
    } else {
        mute = 1;
		console.log("All sounds muted!");
        $("#mute").attr("src","/img/unmute.png");
        $("#mute").attr("title","Unmute");
        setCookie("muted",mute,1);
    }
    audioElement.muted=mute;
    audioElement2.muted=mute;
	audioElement3.muted=mute;
}

window.onload = function onLoad() {
	reloadwinner();
	checkbots();
	circle = new ProgressBar.Circle('#prograsd', {
		color: '#428BCA',
		strokeWidth: 12,
		easing: 'easeInOut',
		trailColor: "#07485b",
		speed: 10000 // opening & closing animation speed
	});
	circle.animate(1);
	setInterval("reloadinfo()",1000);
	setInterval("botstatus()",60000);
};


function alert2(txt,typet) {
	var n = noty({
		layout: 'bottomRight',
		text: txt,
		type: typet,
		theme: 'relax',
		timeout: 10000,
		animation   : {
                    open  : 'animated bounceInDown',
                    close : 'animated bounceOutLeft',
                    easing: 'swing',
                    speed : 500
                }
	});
	audioElement.play();
} 
function checkbots() {
	$.ajax({
		type: "GET",
		url: "../botstatus/steamstatus.php",
		success: function(msg){
			$("#steamstatus").html(msg);
		}
	});
	$.ajax({
		type: "GET",
		url: "online.php",
		success: function(msg){
			$('#onlineu').text(msg);
		}
	});
	$.ajax({
		type: "GET",
		url: "online.php",
		success: function(msg){
			$('#onlinew').text(msg);
		}
	});
}
function botstatus() {
	$.ajax({
		type: "GET",
		url: "../botstatus/steamstatus.php",
		success: function(msg){
			$("#steamstatus").html(msg);
		}
	});
	$.ajax({
		type: "GET",
		url: "online.php",
		success: function(msg){
			$('#onlineu').text(msg);
		}
	});
	$.ajax({
		type: "GET",
		url: "online.php",
		success: function(msg){
			$('#onlinew').text(msg);
		}
	});
}
function reloadwinner() {
	$.ajax({
		type: "GET",
		url: "lastwinner.php",
		success: function(msg){
			$("#winner").text(msg);
		}
	});
	$.ajax({
		type: "GET",
		url: "currentgame.php",
		success: function(msg){
			$("#gameid").text("#"+msg);
		}
	});
	$.ajax({
		type: "GET",
		url: "currentgamehash.php",
		success: function(msg){
			$("#roundhash").text(msg);
		}
	});
	$.ajax({
		type: "GET",
		url: "recent_winners.php",
		success: function(msg){
			$("#recent_winners").html(msg);
		}
	});
}

function reloadinfo() {
	$.ajax({
		type: "GET",
		url: "timeleft.php",
		success: function(msg){
			$('#timeleft').text(msg);
		}
	});
	$.ajax({
		type: "GET",
		url: "currentchance.php",
		success: function(msg){
			$("#mychance").text(msg);
		}
	});
	$.ajax({
		type: "GET",
		url: "currentitems.php",
		success: function(msg){
			if(msg > 100) msg = 100;
			circle.animate(msg/100);
			$('.progressbar__label').text(msg+'/100');
		}
	});
	$.ajax({
		type: "GET",
		url: "currentbank.php",
		success: function(msg){
			$('#bank').text(msg+'');
		}
	});
	$.ajax({
		type: "GET",
		url: "items.php",
		success: function(msg){
			$('.rounditems').html(msg);
		}
	});
}