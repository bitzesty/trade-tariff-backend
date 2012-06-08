//= require jquery
//= require bootstrap
//= require bootstrap-datepicker
//= require dateformat
//= require prettify

$(function(){
  window.prettyPrint && prettyPrint();
  $('#dp').datepicker().on('changeDate', function(ev){
    window.location.href="/stats?q_on=" + ev.date.format("yyyy-mm-dd");
  });
});
