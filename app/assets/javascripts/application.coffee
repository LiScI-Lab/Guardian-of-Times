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
#= require i18n
#= require i18n/translations
#= require moment
#
#= require rails-ujs
#= require turbolinks
#= require jquery
#= require materialize
#= require cocoon
#= require_tree .
#= require Chart.bundle
#= require chartkick

window.timetracker || (window.timetracker = {})

timetracker.app = {}

timetracker.app.init = () ->
  console.log('Application init')
  timetracker.app.materialize()
  return

timetracker.app.cocoonize = (elem) ->

  $(elem).on 'cocoon:after-remove', (e, elem) ->
    if $(elem.context).siblings "[id$=discarded_at]"
      $(elem.context).siblings("[id$=_destroy]").val(false)
      $(elem.context).siblings("[id$=discarded_at]").val(new Date(Date.now()))
    return

  $(elem).on 'cocoon:after-insert', (ev, elem) ->
    console.log(elem)
    timetracker.app.materialize(elem)
  return

timetracker.app.materialize = (elem) ->
  elem || (elem = $('body'))
  M.AutoInit(elem[0])
  $(".dropdown-trigger", elem).dropdown
    constrainWidth: false
  $('input[type="text"]', elem).not('.date,.time,.datetime,.select-dropdown').characterCounter()
  $('textarea', elem).characterCounter()
  $('.modal', elem).modal()
  $('.datepicker', elem).each (_, e) ->
    e = $(e)
    e.datepicker({
      setDefaultDate: true
      autoClose: true
      format: I18n.t('js.date.picker.format')
      defaultDate: new Date(moment(e.val(), I18n.t('js.date.formats.default')).format())
      setDefaultDate: true
      yearRange: 100
      i18n: {
        cancel: I18n.t('js.picker.action.cancel')
        clear: I18n.t('js.picker.action.clear')
        done: I18n.t('js.picker.action.done')
        months: I18n.t('date.month_names')[1..12]
        monthsShort: I18n.t('date.abbr_month_names')[1..12]
        weekdays: I18n.t('date.day_names')
        weekdaysShort: I18n.t('date.abbr_day_names')
        weekdaysAbbrev: I18n.t('date.abbr_day_names')
      }
    })
    return
  $('.timepicker', elem).timepicker({
    autoClose: true
    twelveHour: I18n.t('js.time.twelve_hour')
    i18n: {
      cancel: I18n.t('js.picker.action.cancel')
      clear: I18n.t('js.picker.action.clear')
      done: I18n.t('js.picker.action.done')
    }
  })
  return

timetracker.app.init_chips = (elem, tags, autocomplete_tags) ->
  data = []
  if tags.length > 0
    data = tags.map((v) -> {tag: v})
  if elem[0].hasAttribute("for")
    target = elem.siblings("##{elem.attr('for')}")
    updateTarget = () ->
      chips = M.Chips.getInstance(elem).chipsData
      str = ''
      chips.forEach (chip) ->
        if str != ''
          str = "#{str}, "
        str = "#{str}#{chip.tag}"
      target.val(str)
      return


  autocomplete_data = {}
  autocomplete_tags.forEach (tag) ->
    autocomplete_data[tag] = null
    return
  elem.chips
    data: data
    autocompleteOptions:
      data: autocomplete_data
      limit: Infinity
      minLength: 1
    onChipAdd: updateTarget
    onChipDelete: updateTarget
  return

$(document).on 'turbolinks:load', timetracker.app.init
#$(document).ready timetracker.app.init


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
