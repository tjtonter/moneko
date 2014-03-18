# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
datefmt = (d) ->
  d.getDate() + "." + (d.getMonth() + 1) + "." + d.getFullYear() + " " +
  d.getHours() + ":" + d.getMinutes()

ready = ->
  $('#all_orders_cal').fullCalendar({
    selectable: true
    selectHelper: true
    firstDay: 1
    events: window.location + '.json'
    header: {
      left: 'prev,next today'
      center: 'title'
      right: 'month,agendaWeek,agendaDay'
    }
    weekMode: 'variable'
    select: (startDate, endDate, allDay) ->
      $.get((window.location + '/new'),
      {order:{begin_at: datefmt(startDate), end_at: datefmt(endDate)}},
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
    }
  )

$(document).ready(ready)
$(document).on('page:load', ready)
