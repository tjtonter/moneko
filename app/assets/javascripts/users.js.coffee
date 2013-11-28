# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(".order-item").bind "ajax:success", (e, data, status, xhr) ->
    $("#panel-div").html(xhr.responseText)
    alert(data.responseText)

