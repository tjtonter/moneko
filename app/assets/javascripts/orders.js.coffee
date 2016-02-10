# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
fetch_events = (start, end, timezone, callback) ->
  $.ajax({
    url: 'http://'+window.location.host+'/orders.json'
    dataType: 'json'
    data: {
      start: start.unix()
      end: end.unix()
    }
    success: (data) ->
      dtstart = new Date(start)
      dtend   = new Date(end)
      id      = $('#user-nav').data('user-id')
      events = []
      for order in data
        if order.ical
          msdelta = Date.parse(order.end_at) - Date.parse(order.begin_at)
          options = RRule.parseString(order.ical)
          options.dtstart = new Date(order.begin_at)
          options.until = new Date(order.until_at)
          rule = new RRule(options)
          dates = rule.between(dtstart, dtend)
          for date in dates
            d2 = new Date(Date.parse(date)+msdelta)
            event = {
              id: order.id
              title: order.title
              start: date.toString()
              end: d2.toString()
              url: Routes.order_path(order.id)
            }
            events.push event
        else
          event = {
            id: order.id
            title: order.title
            start: order.begin_at
            end: order.end_at
            url: Routes.order_path(order.id)
          }
          events.push event
      callback events
  })

eventmove = (event,delta,revertFunc) ->
  console.log event
  $.ajax({
    type: 'PUT'
    url: window.location + '/' + event.id
    data: {
      order: {
        id: event.id
        user_ids: event.user_ids
        begin_at: event.start.format()
        end_at: if event.end then event.end.format() else null
        allday: event.allDay
      }
    }
  })

eventresize = (event, delta, revertFunc) ->
  console.log "muutos=" + delta
  console.log event
  $.ajax({
    type: 'PUT'
    url: window.location + '/' + event.id
    data: {
      order: {
        id: event.id
        user_ids: event.user_ids
        begin_at: event.start.format()
        end_at: event.end.format()
        allday: event.allDay
      }
    }
  })

# This if triggered when a jQuery UI draggable element is dropped into calendar.
eventdrop = (moment, jsEvent, ui) ->
  event = $(this).data('eventObject')
  copy = $.extend({}, event)
  copy.start = moment

  console.log "Dropped event: " + copy
  $.ajax({
    type: 'POST'
    url: window.location
    data: {
      order: {
        title: event.title
        user_ids: event.user_ids
        begin_at: moment.format()
      }
    }
  })
  $('#all_orders_cal').fullCalendar('refetchEvents')
  console.log "Calendar updated."

eventselect2 = (start, end, allday) ->
  window.location = Routes.new_order_path(order:
    {
      begin_at: start.format()
      end_at: end.format()
    })

eventselect = (startDate, endDate, allDay) ->
  $.get((window.location.origin + '/orders/new'),
  {order:{begin_at: startDate.format(), end_at: endDate.format()}},
  ((data, textStatus) ->
    $('#modalcontent').html(data)
    $('#modal-title').html("Uusi työmääräys")
    $('#modal').modal('show')
    $('#order_allday').on 'click', () ->
      if $(this).is(':checked')
        $('#order_end_at').prop('disabled', true)
      else
        $('#order_end_at').prop('disabled', false)
    $('#repeat').on 'click', () ->
      console.log "Changing state"
      if $(this).is(':checked')
        $('.btn-day').prop('disabled', false)
      else
        $('.btn-day').prop('disabled', true)
    $('.btn-day').on 'click', () ->
      $(this).toggleClass 'btn-primary'
      
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
  
disable_rules = () ->
  recurring = $('#order_recurring').prop('checked')
  $('#order_rule').prop('disabled', !recurring)
  $('#order_until_at').prop('disabled', !recurring)

ready = ->
  $('#order_recurring').on('click', disable_rules)
  $('#all_orders_cal').fullCalendar({
    editable: true
    selectable: true
    selectHelper: true
    firstDay: 1
    events: fetch_events
    height: 700
    header: {
      left: 'prev,next today'
      center: 'title'
      right: 'month,agendaWeek,agendaDay'
    }
    weekMode: 'variable'
    #droppable: true
    #drop: eventdrop
    #eventDrop: eventmove
    #eventResize: eventresize
    select: eventselect2
    timezone: "Europe/Helsinki"
    }
  )

$(document).ready(ready)
$(document).on('page:load', ready)
