# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $("#job_description").autocomplete(source: "/orders.json")
#  $("#job_description").autocomplete(source: ["matti", "teppo", "seppo"])
  $("#job_date").datepicker()
