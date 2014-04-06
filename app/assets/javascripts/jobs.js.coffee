# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $('#job-search').hide()
  $('#job-form-toggle').on('click', ->
    $('#job-search').toggle(500)
  )
  $('.edit_job').on('ajax:success', ((e, data, st, xhr) ->
    $('#modalcontent').html(data)
    if $("#job_begin").val()
      a = $('#job_begin').val().split(':')
    if $("#job_end").val()
      b = $('#job_end').val().split(':')
    $('#slider').slider({
      range: true
      min: 0
      max: 1440
      step: 15
      values: [parseInt(a[0])*60+parseInt(a[1]), parseInt(b[0])*60+parseInt(b[1])]
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
    $('#modal-title').html('Muokkaa työtä')
    $('#modal').modal('show')
    $('edit_job').on('ajax:success', ((e, data, st, xhr) ->
      console.log("Läpi meni!")
    ))
  ))

$(document).ready(ready)
$(document).on('page:load', ready)
