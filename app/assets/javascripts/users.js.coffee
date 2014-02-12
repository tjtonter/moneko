# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

load_jobs = (event, data, status, xhr) ->
  $('#user_jobs').html xhr.responseText
  $('#jobmodal').modal('hide')

add_job_row = (event, data, status, xhr) ->
  $('#user_jobs_table tbody:last').append xhr.responseText
  $('#jobmodal').modal('hide')

load_modal = (event, data, status, xhr) -> 
  $('#modalcontent').html xhr.responseText
  $('#new_job').on 'ajax:success', load_jobs

ready = ->
  $('.add-job').on 'ajax:success', load_modal
  $('#user_calendar').fullCalendar({
    events: window.location + '/tasks.json'
    eventClick: (event) -> 
      if event.url
        $('#modalcontent').html('Ladataan lomaketta...')
        $('#jobmodal').modal('show')
        req = $.ajax({
          url: event.url
        })
        req.done (html) ->
          $('#modalcontent').html(html)
          $('#job_duration').spinner
          $('#new_job').on 'ajax:success', add_job_row
          $('#job_date').datepicker({showOn: 'button', dateFormat: 'dd.mm.yy'})
      return false
  })

$(document).ready(ready)
$(document).on('page:load', ready)
