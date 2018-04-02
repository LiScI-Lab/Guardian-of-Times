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
#= require materialize
#= require_tree .

window.timetracker || (window.timetracker = {})

timetracker.app = {}

timetracker.app.init = () ->
  console.log('Application init')
  timetracker.app.materialize()
  return

timetracker.app.materialize = (elem) ->
  elem || (elem = $('body'))
  M.AutoInit(elem[0])
  $(".dropdown-trigger", elem).dropdown
    constrainWidth: false
  $('input[type="text"]', elem).characterCounter()
  $('textarea', elem).characterCounter()

  $('.modal', elem).modal()
  return

$(document).on 'turbolinks:load', timetracker.app.init
$(document).ready timetracker.app.init


jQuery.fn.changeTag = (newTag) ->
  q = this
  @each (i, el) ->
    h = '<' + el.outerHTML.replace(/(^<\w+|\w+>$)/g, newTag) + '>'
    try
      el.outerHTML = h
    catch e
      #elem not in dom
      q[i] = jQuery(h)[0]
    return
  this