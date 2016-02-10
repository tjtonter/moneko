ready = ->
  $('#job-search').hide()
  $('#job-form-toggle').on('click', ->
    $('#job-search').toggle(500)
  )
  $('.edit_job').on('ajax:success', ((e, data, st, xhr) ->
    $('#modalcontent').html(data)
    $('#modal-title').html('Muokkaa työtä')
    $('#modal').modal('show')
    $('#edit_'+e.target.id).on('ajax:success', ((e, data, st, xhr) ->
      $.each(data, ((k,v) ->
        switch k
          when 'date' then $('#'+data.id+" td."+k).html(moment(v).format('DD.MM.YYYY'))
          when 'salary' then $('#'+data.id+" td."+k).html(accounting.formatMoney(parseInt(v)))
          else $('#'+data.id+" td."+k).html(v)
      ))
      $('#modal').modal('hide')
    ))
  ))

$(document).ready(ready)
$(document).on('page:load', ready)
