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
          rule = new RRule(options)
          dates = rule.between(dtstart, dtend)
          for date in dates
            d2 = new Date(Date.parse(date)+msdelta)
            event = {
              id: order.id
              title: order.title
              start: date.toString()
              end: d2.toString()
              url: Routes.new_user_job_path(id, order_id: order.id,job: { date: date})
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
    eventClick: (event) ->
      if event.url
        $.get(event.url, ((data) ->
          $('#modalcontent').html(data)
          $('#modal-title').html('Rekisteröi työ')
          $('#slider').slider({
            range: true
            min: 0
            max: 1440
            step: 15
            values: [8*60, 16*60]
            slide: (e, ui) ->
              ahour = Math.floor(ui.values[0] / 60)
              amin = ui.values[0] - ahour * 60
              bhour = Math.floor(ui.values[1] / 60)
              bmin = ui.values[1] - bhour * 60
              delta = ui.values[1] - ui.values[0]
              $("#job_begin").val(ahour+ ":"+(if amin == 0 then '00' else amin))
              $("#job_end").val(bhour+ ":"+(if bmin == 0 then '00' else bmin))
              $("#job_duration").val(delta/60)
          })
          $('#new_job').on('ajax:success', ((e, data, st, xhr) ->
            $('#modal').modal('hide')
            alert "Uusi työpäivä rekisteröity."
          ))
        ))

        $('#modal').modal('show')
        return false
    header: {
      left: 'prev,next today'
      center: 'title'
      right: 'month,agendaWeek,agendaDay'
    }
    #theme: true
    firstDay: 1
    weekMode: 'variable'
    weekNumbers: true
    allDayText: 'Kokopäivän'
    formatDate: 'HH:mm'
  })

$(document).ready(ready)
$(document).on('page:load', ready)

