// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require_tree .


$(function() {
	$("#alert").click(function() {
	  alert(this.getAttribute("data-message"));
	  return false;
	})
})

var maxLen = 160; //Micropost::MAXIMUM_MICROPOST_LENGTH;

$(function() { 
	setCharCount($('#micropost_content')); 
});

$('#micropost_content').live('keyup keydown', function(e) { 
	setCharCount($(this)); 
});

function setCharCount(object) {	
	var left = maxLen - object.val().length;  
	$('#char-count').html(left);
}
