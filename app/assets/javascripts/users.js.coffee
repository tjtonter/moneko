# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $("#panel-content").hide()
  $(".order-item").bind "ajax:success", (e, data, status, xhr) ->
    $("#panel-content").html(xhr.responseText)
    $("#panel-content").slideDown()
  $(".order-item").bind "ajax:error", (e, xhr, status, error) ->
    $("#panel-content").html(error)

$(document).ready(ready)
$(document).on('page:load', ready)
