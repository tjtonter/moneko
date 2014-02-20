# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$.datepicker.setDefaults( $.datepicker.regional[ "fi" ] )
dp_options = {
  #altField: "#order_begin_at"
  #altFieldTimeOnly: false
  #gotoCurrent: true
  dateFormat: "dd.mm.yy"
  timeFormat: "H:mm"
  showAnim: "slideDown"
  stepMinute: 15

}
ready = ->
  $('#order_begin_at').datetimepicker(dp_options) 
  $('#order_end_at').datetimepicker(dp_options)
$(document).ready(ready)
$(document).on('page:load', ready)
