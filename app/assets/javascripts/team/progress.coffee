window.timetracker || (window.timetracker = {})

timetracker.team || (timetracker.team = {})

timetracker.team.progress = {}

timetracker.team.progress.init = () ->
  return if $('body.team.progresses').size is 0
  console.log('Team Progresses init')
  timetracker.team.progress.ongoingProgresses()
  return

timetracker.team.progress.ongoingProgresses = (elem) ->
  elem || (elem = $('body'))

  $('tr.ongoing', elem).each (_, e) -> timetracker.team.progress.ongoingProgress($(e))


timetracker.team.progress.ongoingProgress = (elem) ->
  start = Date.parse(elem.data('start'))
  duration_in_seconds = Math.round((Date.now() - start) / 1000)
  $('td.duration', elem).html(dotiw.timeAgoInWords(start, duration_in_seconds < dotiw.TimeHash.HOUR))
  setTimeout(() ->
    timetracker.team.progress.ongoingProgress(elem)
  , 1000 * if duration_in_seconds < dotiw.TimeHash.HOUR then 1 else dotiw.TimeHash.MINUTE)


$(document).on 'turbolinks:load', timetracker.team.progress.init