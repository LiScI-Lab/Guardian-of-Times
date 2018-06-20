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