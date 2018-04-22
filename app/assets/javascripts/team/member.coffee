# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.timetracker || (window.timetracker = {})

timetracker.team || (timetracker.team = {})

timetracker.team.member = {}

timetracker.team.member.init = () ->
  return if $('body.team.members').size is 0
  console.log('Team Member init')
  return

timetracker.team.member.cocoonize = (elem) ->
  $(elem).on 'cocoon:after-insert', (ev, e) ->
    timetracker.team.member.materialize(e)
  return

timetracker.team.member.materialize = (elem) ->
  $('.date.form-control', elem).each (_, e) ->
    disableDayFn = (day) ->
      return (new Date(day)).getDate() isnt 1
    M.Datepicker.init e, {
      disableDayFn: disableDayFn
      format: 'yyyy-mm-dd'
    }
  return

$(document).on 'turbolinks:load', timetracker.team.member.init
#$(document).ready timetracker.team.member.init