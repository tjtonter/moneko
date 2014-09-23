ready = ->
  $('.destroy_service').on 'click', ->
    $(this).prev().val(1)
    $(this).parents('.service').hide(1000)
    return false
  $('form').on "ajax:success", (evt, data, status, xhr) ->
    alert "Uusi työmääräys luotu!"
    $('#order-form-div').toggleClass('hide')
  $('li a').on "ajax:success", (evt, data, status, xhr) ->
    $('#dropdownmenu-'+data.id).html(this.innerHTML + ' <span class="caret"></span>')
    $('#dropdownmenu-'+data.id).dropdown('toggle')
  $('a.service-link').on 'ajax:success', (evt, data, status, xhr) ->
    $('#modalcontent').html(data)
    $('#order_title').val($(this).html())
    $('#order_salary').val($(this).data('salary')*$(".progress-bar").data('salary')/100)
    $('#modal').modal('show')
    $('#new_order').on 'ajax:success', (evt, data, status, xhr) ->
      alert "Työmääräys luotu"
      $('#modal').modal('hide')
  $('a.salary-link').on 'click', (evt) ->
    evt.preventDefault()
    salary = $('.progress-bar').data('salary') + $(this).data('delta')
    $.ajax({
      type: "PUT",
      url: $(this).attr('href'),
      data: {offer:{salary: salary}},
      success: (data, status, xhr) ->
        $('.progress-bar').css('width', data.salary+"%")
        $('.progress-bar').html(data.salary+" %")
        $('.progress-bar').data('salary', data.salary)
    })

$(document).ready(ready)
$(document).on('page:load', ready)
