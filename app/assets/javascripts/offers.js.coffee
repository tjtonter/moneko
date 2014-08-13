ready = ->
  $('.destroy_service').on 'click', ->
    $(this).prev().val(1)
    $(this).parents('.service').hide(1000)
    return false
  $('li a').on "ajax:success", (evt, data, status, xhr) ->
    $('#dropdownmenu-'+data.id).html(this.innerHTML + ' <span class="caret"></span>')
    $('#dropdownmenu-'+data.id).dropdown('toggle')
$(document).ready(ready)
$(document).on('page:load', ready)
