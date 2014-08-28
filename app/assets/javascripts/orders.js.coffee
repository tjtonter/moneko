# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
datefmt = (d) ->
  d.getDate() + "." + (d.getMonth() + 1) + "." + d.getFullYear() + " " +
  d.getHours() + ":" + d.getMinutes()
  
eventmove = (event,delta,revertFunc) ->
  console.log "muutos=" + delta
  $.ajax({
    type: 'PUT'
    url: window.location + '/' + event.id
    data: {
      order: {
        id: event.id
        user_ids: event.user_ids
        begin_at: event.start.format()
        end_at: event.end.format()
      }
    }
  })

eventresize = (event, delta, revertFunc) ->
  console.log "muutos=" + delta
  $.ajax({
    type: 'PUT'
    url: window.location + '/' + event.id
    data: {
      order: {
        id: event.id
        user_ids: event.user_ids
        begin_at: event.start.format()
        end_at: event.end.format()
      }
    }
  })

eventselect = (startDate, endDate, allDay) ->
  $.get((window.location + '/new'),
  {order:{begin_at: startDate.format(), end_at: endDate.format()}},
  ((data, textStatus) ->
    $('#modalcontent').html(data)
    $('#modal-title').html("Uusi työmääräys")
    $('#modal').modal('show')
    $('#new_order').on('ajax:success', (e, data, status, xhr) ->
        $('#modal').modal('hide')
        alert "Uusi työpäivä rekisteröity."
        $('#all_orders_cal').fullCalendar('refetchEvents')
    )
    $('#new_order').on('ajax:error', (e, xhr, status, error) ->
      json = $.parseJSON(xhr.responseText)
      $('.form-group').removeClass('has-error')
      $('.help-block').html('')
      $.each(json, (k, v) ->
        $('#order_'+k).parents('.form-group').addClass('has-error')
        $('#'+k+'_errors').html(v))
    )
  ), "html")
  $('#all_orders_cal').fullCalendar('unselect')

ready = ->
  $('#all_orders_cal').fullCalendar({
    editable: true
    selectable: true
    selectHelper: true
    firstDay: 1
    events: window.location + '.json'
    height: 700
    header: {
      left: 'prev,next today'
      center: 'title'
      right: 'month,agendaWeek,agendaDay'
    }
    weekMode: 'variable'
    eventDrop: eventmove
    eventResize: eventresize
    select: eventselect
    }
  )

$(document).ready(ready)
$(document).on('page:load', ready)
