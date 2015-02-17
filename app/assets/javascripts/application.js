// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap
//= require moment
//= require bootstrap-datetimepicker
//= require moment/fi
//= require locales/bootstrap-datetimepicker.fi.js
//= require jquery_nested_form
//= require recurring_select
//= require js-routes
//= require_tree .

/* Finnish initialisation for the jQuery UI date picker plugin. */
/* Written by Harri Kilpi� (harrikilpio@gmail.com). */
jQuery(function($){
  $.datepicker.regional['fi'] = {
    closeText: 'Sulje',
    prevText: '&laquo;Edellinen',
    nextText: 'Seuraava&raquo;',
    currentText: 'T&auml;n&auml;&auml;n',
    monthNames: ['Tammikuu','Helmikuu','Maaliskuu','Huhtikuu','Toukokuu','Kes&auml;kuu',
    'Hein&auml;kuu','Elokuu','Syyskuu','Lokakuu','Marraskuu','Joulukuu'],
    monthNamesShort: ['Tammi','Helmi','Maalis','Huhti','Touko','Kes&auml;',
    'Hein&auml;','Elo','Syys','Loka','Marras','Joulu'],
    dayNamesShort: ['Su','Ma','Ti','Ke','To','Pe','Su'],
    dayNames: ['Sunnuntai','Maanantai','Tiistai','Keskiviikko','Torstai','Perjantai','Lauantai'],
    dayNamesMin: ['Su','Ma','Ti','Ke','To','Pe','La'],
    weekHeader: 'Vk',
    dateFormat: 'dd.mm.yy',
    firstDay: 0,
    isRTL: false,
    showMonthAfterYear: false,
    yearSuffix: ''};
  $.datepicker.setDefaults($.datepicker.regional['fi']);
});
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
  $('.datetimeinput').datetimepicker({
    language: 'fi',
    minuteStepping: 15,
    defaultDate: new Date(),
    format: 'DD.MM.YYYY HH:mm',
    sideBySide: true
  });
  $('.dateinput').datetimepicker({
    language: 'fi',
    pickTime: false
    /* defaultDate: new Date() */
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
