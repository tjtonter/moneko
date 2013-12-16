# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#add_class = -> 
#  $(this).siblings().removeClass("active")
#  $(this).addClass("active") 

ready = ->
  $('.add-job').on 'ajax:success', (event, data, status, xhr) ->
    console.log(status)
    $('#modalcontent').html xhr.responseText

$(document).ready(ready)
$(document).on('page:load', ready)
