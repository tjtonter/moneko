# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$.datepicker.setDefaults( $.datepicker.regional[ "fi" ] )

ready = ->
  #console.log "ready suoritettu"
  $('#order_begin_at').datetimepicker(
    {
      #altField: "#order_begin_at"
      #altFieldTimeOnly: false
      #gotoCurrent: true
      dateFormat: "dd.mm.yy"
      timeFormat: "h:mm"
      showAnim: "slideDown"
    }
  ) 
  $('#order_end_at').datetimepicker(
    {
      #altField: "#order_end_at"
      #altFieldTimeOnly: false
      #gotoCurrent: true
      dateFormat: "dd.mm.yy"
      timeFormat: "h:mm"
      showAnim: "slideDown"
    }
  )

$(document).ready(ready)
$(document).on('page:load', ready)
