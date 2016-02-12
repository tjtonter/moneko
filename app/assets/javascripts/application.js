//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require moment
//= require moment/fi
//= require turbolinks
//= require bootstrap-datetimepicker
//= require bootstrap-slider
//= require jquery_nested_form
//= require recurring_select
//= require recurring_select/fi
//= require fullcalendar
//= require fullcalendar/lang/fi
//= require js-routes
//= require_tree .

/* Set accounting.js defaults */
accounting.settings = {
  currency: {
  symbol : "€",   // default currency symbol is '$'
  format: "%v %s", // controls output: %s = symbol, %v = value/number (can be object: see below)
  decimal : ",",  // decimal point separator
  thousand: ".",  // thousands separator
  precision : 2   // decimal places
  },
  number: {
    precision : 0,  // default precision on numbers is 0
    thousand: ".",
    decimal : ","
  }
}
function ready() {
/* Bind all .datetime classes with respective pickers */
  $('.timeinput').datetimepicker({
    format: 'HH:mm',
    stepping: 30
  });
  $('.dateinput').datetimepicker({
    format: 'DD.MM.YYYY'
  });
  $('.dateinput-inline').datetimepicker({
    format: 'DD.MM.YYYY',
    inline: true
  });
  $('.datetimeinput').datetimepicker({
    stepping: 30,
    format: 'DD.MM.YYYY HH:mm',
    sideBySide: true
  });
/* Bind error handler for all remote forms */
  $("form[data-remote='true']").on('ajax:error', function(e, xhr, status, error) {
    var json = $.parseJSON(xhr.responseText);
    $('.form-group').removeClass('has-error');
    $('.help-block').html('');
    return $.each(json, function(k, v) {
      $('#job_'+k).parents('.form-group').addClass('has-error');
      $('#'+k+'_error').html(v);
    });
  });
  /* Bind ajax trigger for order state change buttons */
  $('.btn-state').on('ajax:success', function(e, data, st, xhr) {
    $('.btn-state').removeClass('btn-primary')
    $(this).addClass('btn-primary')
    $('#user_calendar').fullCalendar('refetchEvents')
  });
}

$(document).ready(ready);
$(document).on('page:update', ready);
