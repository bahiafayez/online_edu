# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


jQuery ->
  $('.best_in_place').best_in_place()
  $.datepicker.setDefaults({ dateFormat: 'dd M (D)' });
  
# jQuery ->
   # $.extend($.fn.datepicker.defaults, { format: 'dd M D' });
# 


$("#show_now").click ->
  console.debug "hreeee"
  alert "Handler for .click() called."
  

update = (student) ->
  alert student

#$(document).ready ->  
#  document.getElementById(b).parentNode.parentNode.style.display = "none"
#   username =  @student.name 
