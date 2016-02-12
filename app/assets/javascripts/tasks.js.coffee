event_click = (event) ->
  if event.url
    $.get(event.url, ((data) ->
      $('#modalcontent').html(data)
      $('#modal-title').html('Rekisteröi työ')
      $('#new_job').on('ajax:success', ((e, data, st, xhr) ->
        $('#modal').modal('hide')
        alert "Uusi työpäivä rekisteröity."
        $('#modalcontent').html()
      ))
    ))

    $('#modal').modal('show')
    return false

day_click = (event) ->
  console.log event

fetch_events = (start, end, timezone, callback) ->
  $.ajax({
    url: Routes.user_tasks_path($('#user-nav').data('user-id'), {format: "json"})
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
              start: moment(date).format()
              end: moment(d2).format()
              url: Routes.new_user_job_path(id, order_id: order.id,job: { date: date})
            }
            events.push event
        else
          event = {
            id: order.id
            title: order.title
            start: order.begin_at
            end: order.end_at
            url: Routes.new_user_job_path(id, order_id: order.id,job: { date: order.begin_at})
          }
          events.push event
      callback events
    context: {
      start: start
      end: end
    }
  })
   

ready = ->
  modal = $('#modal')
  $('#user_calendar').fullCalendar({
    events: fetch_events
    eventClick: event_click
    dayClick: day_click
    header: {
      left: 'prev,next today'
      center: 'title'
      right: 'month,agendaWeek,agendaDay'
    }
    firstDay: 1
    weekMode: 'variable'
    weekNumbers: true
    allDayText: 'Kokopäivän'
    formatDate: 'HH:mm'
  })

$(document).ready(ready)
$(document).on('page:load', ready)

