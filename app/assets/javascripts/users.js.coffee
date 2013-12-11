# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#add_class = -> 
#  $(this).siblings().removeClass("active")
#  $(this).addClass("active") 

ready = ->
  $("#accordion").accordion()
#  $("#panel-content").hide()
#  $(".order-item").bind "ajax:success", (e, data, status, xhr) ->
#    $("#panel-content").html(xhr.responseText)
#    $("#panel-content").slideDown()
#  $(".order-item").bind "ajax:error", (e, xhr, status, error) ->
#    $("#panel-content").html(error)
#
#  $(".order-item").click(add_class)
#
$(document).ready(ready)
$(document).on('page:load', ready)
