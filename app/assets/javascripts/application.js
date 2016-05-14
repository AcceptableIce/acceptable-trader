// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require modernizr
//= require jquery
//= require jquery_ujs
//= require select2
//= require foundation
//= require foundation-datetimepicker
//= require react
//= require react_ujs
//= require components
//= require_tree .

$(function(){ 
	$(document).foundation(); 
	fixFooter(-10);
});

$(window).resize(function() {
  fixFooter(0);
});

function fixFooter(offset) {
  footer = $("footer");
  height = footer.height();
  paddingTop = parseInt(footer.css('padding-top'), 10);
  paddingBottom = parseInt(footer.css('padding-bottom'), 10);
  totalHeight = (height + paddingTop + paddingBottom);
  footerPosition = footer.position();
  windowHeight = $(window).height() - offset;
  height = (windowHeight - footerPosition.top) - totalHeight;
  if ( height > 0 ) footer.css({ 'margin-top': (height) + 'px' });
}