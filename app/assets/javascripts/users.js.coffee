# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

load_jobs = (event, data, status, xhr) ->
    $('#user_jobs').html xhr.responseText
    $('#jobmodal').modal('hide')

load_modal = (event, data, status, xhr) -> 
  $('#modalcontent').html xhr.responseText
  $('#new_job').on 'ajax:success', load_jobs

ready = ->
  $('.add-job').on 'ajax:success', load_modal
  $('#calendar').fullCalendar({events: window.location.href + '/jobs.json'})

$(document).ready(ready)
$(document).on('page:load', ready)
