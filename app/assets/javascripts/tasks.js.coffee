# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  modal = $('#modal')
  $('#user_calendar').fullCalendar({
    events: window.location + '.json'
    eventClick: (event) ->
      if event.url
        path = 'http://' + window.location.host + event.url
        $.get(path, ((data) ->
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
          $('.btn-state').on('click', (e) ->
            e.preventDefault()
            $('.btn-state').removeClass('btn-primary')
            $(this).addClass('btn-primary')
            id = e.target.dataset.order
            st = e.target.dataset.status
            users = e.target.dataset.users
            $.ajax({
              url: 'http://'+window.location.host+'/orders/'+id
              data: {order: {status: st, user_ids: users, id: id}}
              type: 'PATCH'
              success: (data, textStatus, jqXHR) ->
                $('#user_calendar').fullCalendar('refetchEvents')
            })
          )
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

