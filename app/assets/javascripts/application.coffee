############
##
## Copyright 2018 M. Hoppe & N. Justus
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
## http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
############

#= require rails-ujs
#= require turbolinks
#= require jquery
#= require materialize
#= require cocoon
#
#= require i18n
#= require i18n/translations
#= require moment
#= require Chart.bundle
#= require chartkick
#
#= require_tree .

window.timetracker || (window.timetracker = {})

timetracker.app = {}

timetracker.app.init = () ->
  console.log('Application init')
  timetracker.app.materialize()
  elem = document.querySelector('.collapsible.expandable')
  instance = M.Collapsible.init(elem, {
    accordion: false
  })
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
  $(".dropdown-trigger.no-autoinit", elem).dropdown
    constrainWidth: false
    autoTrigger: true
    coverTrigger: false

  sidenavs = $('.sidenav.no-autoinit')
  sidenavs.sidenav()
  sidenavs.each (_, nav) ->
    id = $('.sidenav.no-autoinit').attr('id')
    $(".sidenav-trigger[data-target=\"#{id}\"").click () ->
      $(nav).sidenav('open')
      return
    return

  $('input[type="text"].character-count', elem).not('.date,.time,.datetime,.select-dropdown').characterCounter()
  $('textarea', elem).characterCounter()
  $('.modal', elem).modal()
  $('.datepicker.no-autoinit', elem).not('.manual').each (_, e) ->
    e = $(e)
    e.datepicker({
      setDefaultDate: true
      autoClose: true
      format: I18n.t('js.date.picker.format')
      defaultDate: new Date(moment(e.val(), I18n.t('js.date.formats.default')).format())
      setDefaultDate: true
      yearRange: 100
      showClearBtn: e.hasClass('optional')
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
  $('.timepicker', elem).not('.manual').each (_, e) ->
    e = $(e)
    e.timepicker({
      autoClose: true
      twelveHour: I18n.t('js.time.twelve_hour')
      showClearBtn: e.hasClass('optional')
      i18n: {
        cancel: I18n.t('js.picker.action.cancel')
        clear: I18n.t('js.picker.action.clear')
        done: I18n.t('js.picker.action.done')
      }
    })
  $('input.boolean.tooltipped,input.date.tooltipped', elem).each (_, e) ->
    e = $(e)
    parent = e.parents('.boolean,.date')
    data = e.data()
    data['html'] = data['tooltip']
    M.Tooltip.init(parent,data)
    i = M.Tooltip.getInstance(e)
    if i isnt undefined
      M.Tooltip.getInstance(e).destroy()
  M.updateTextFields()
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
