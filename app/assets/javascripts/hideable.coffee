window.timetracker || (window.timetracker = {})

timetracker.hideable = {}
timetracker.hideable.init = () ->
  console.log('hideable init')
  timetracker.hideable.init_element($('.has-hideable-content'))

  $(document).on 'cocoon:after-insert', (ev, elem) ->
    timetracker.hideable.init_element(elem)
    return

timetracker.hideable.init_element = (elem) ->
  $('.hide-selector select', elem).on 'change', (ev) ->
    timetracker.hideable.disable_block ev.target
    return
  return

timetracker.hideable.disable_block = (elem) ->
  elem = $(elem)
  hideable_parent = elem.parents('.has-hideable-content').first()
  val = elem.val()
  $('.hideable', hideable_parent).hide()
  $(".hideable.#{val}", hideable_parent).show()
  return