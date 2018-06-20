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

window.materializeForm || (window.materializeForm = {})

materializeForm.init = (elem) ->
  elem || (elem = $('body'))
  materializeForm.initSelect(elem)
  return

materializeForm.initSelect = (elem) ->
  $('select[multiple="multiple"] option[value=""]', elem).attr('disabled', true)
  $('select', elem).formSelect()
  return