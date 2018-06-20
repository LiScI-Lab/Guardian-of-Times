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

window.timetracker || (window.timetracker = {})

timetracker.team || (timetracker.team = {})

timetracker.team.member = {}

timetracker.team.member.init = () ->
  return if $('body.team.members').size is 0
  console.log('Team Member init')
  timetracker.hideable.init()
  return

timetracker.team.member.cocoonize = (elem) ->
  $(elem).on 'cocoon:after-insert', (ev, e) ->
    timetracker.team.member.materialize(e)
  return

timetracker.team.member.materialize = (elem) ->
  $('.datepicker.manual', elem).each (_, e) ->
    disableDayFn = (day) ->
      return (new Date(day)).getDate() isnt 1
    e = $(e)
    e.datepicker({
      setDefaultDate: true
      autoClose: true
      format: I18n.t('js.date.picker.format')
      defaultDate: new Date(moment(e.val(), I18n.t('js.date.formats.default')).format())
      disableDayFn: disableDayFn
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

$(document).on 'turbolinks:load', timetracker.team.member.init