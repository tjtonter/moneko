ready = ->
  $('.destroy_service').on 'click', ->
    $(this).prev().val(1)
    $(this).parents('.service').hide(1000)
    return false

$(document).ready(ready)
$(document).on('page:update', ready)
