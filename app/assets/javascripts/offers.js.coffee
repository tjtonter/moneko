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
  $('a#toggle-order-form').on 'click', (evt) ->
    evt.preventDefault()
    $('#order-form-div').toggleClass('hide')
  $('a.service-link').on 'click', (evt) ->
    evt.preventDefault()
    percent = $('#salary').val() / 100
    salary = percent * ($(this).data('value'))
    $('#order_title').val($(this).html())
    $('#order_salary').val(salary)

$(document).ready(ready)
$(document).on('page:load', ready)
