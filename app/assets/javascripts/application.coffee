# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
# vendor/assets/javascripts directory can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file. JavaScript code in this file should be added after the last require_* statement.
#
# Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require rails-ujs
#= require turbolinks
#= require jquery
#= require bootstrap-sprockets
#= require_tree .

window.timetracker || (window.timetracker = {})

timetracker.dismissFlash = () ->
  flash = $('#flash')
  $('.alert', flash).each (i, elem) ->
    setTimeout (->
      $(elem).alert('close')
      return
    ), 2500
    return

  return

timetracker.init = () ->
  console.log('Application init')
  timetracker.dismissFlash()
  return

$(document).ready(timetracker.init)