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

window.dotiw || (window.dotiw = {})
dotiw.DEFAULT_I18N_SCOPE = 'datetime.dotiw'

dotiw.t = (scope, options) ->
  if(I18n)
    val = I18n.t(scope, options)
    if val is "[missing \"#{I18n.locale}.#{scope}\" translation]" and options['default']
      val = I18n.t(options['default'], options)
    val
  else
    'not implemented'


dotiw.distanceOfTimeInWordsHash = (fromTime, toTime, options = {}) ->
  new dotiw.TimeHash(null, fromTime, toTime, options).to_hash()

dotiw.distanceOfTime = (seconds, options = {}) ->
  options['includeSeconds'] ||= true
  dotiw.displayTimeInWords new dotiw.TimeHash(seconds, null, null, options).to_hash, options

dotiw.distanceOfTimeInWords = (fromTime, toTime = 0, includeSecondsOrOptions = {}, options = {}) ->
  if includeSecondsOrOptions instanceof Object
    options = includeSecondsOrOptions
  else
    options['includeSeconds'] ||= !!includeSecondsOrOptions

  dotiw.displayTimeInWords dotiw.distanceOfTimeInWordsHash(fromTime, toTime, options), options

dotiw.distanceOfTimeInPercentage = (fromTime, currentTime, toTime, options) ->
  options['precision'] ||= 0
  result = ((currentTime - fromTime) / (toTime - fromTime)) * 100
  "#{Math.round(result, options['precision'])}%"

dotiw.timeAgoInWords = (fromTime, includeSecondsOrOptions = {}) ->
  dotiw.distanceOfTimeInWords(fromTime, Date.now(), includeSecondsOrOptions)

dotiw.displayTimeInWords = (hash, options = {}) ->
  include_seconds = options['includeSeconds'] || false
  delete options['includeSeconds']

  delete hash['seconds'] if !include_seconds and hash['minutes']

  if options['except'] and typeof options['except'] is 'string'
    options['except'] = [options['except']]

  if options['only'] and typeof options['only'] is 'string'
    options['only'] = [options['only']]

  tmp_hash = hash

  for key, value of hash
    if (not value) or (options['except'] and key not in options['except']) or (options['except'] and key in options['only'])
      delete hash[key]

  i18n_scope = options['scope'] || dotiw.DEFAULT_I18N_SCOPE
  fractions = dotiw.TimeHash.TIME_FRACTIONS
  if Object.keys(hash).length is 0
    fractions = fractions.filter((val) -> val in options['only']) if options['only']
    fractions = fractions.filter((val) -> val not in options['except']) if options['except']

    return dotiw.t("#{i18n_scope}.less_than_x", {
      distance: dotiw.t("#{i18n_scope}.#{fractions[0]}", {count: 1})
      default: dotiw.t("#{i18n_scope}.#{fractions[0]}", {count: 0})
    })

  else
    output = []
    for key in fractions.slice().reverse()
      output = [output..., dotiw.t("#{i18n_scope}.#{key}", {count: hash[key]})] if hash[key]

    highest_measures = options['highestMeasures']
    highest_measures = 1 if options['highestMeasuresOnly']
    if highest_measures
      output = output[0...highest_measures]

    words_connector = dotiw.t 'datetime.dotiw.words_connector', {default: 'support.array.words_connector'}
    two_words_connector = dotiw.t 'datetime.dotiw.two_words_connector', {default: 'support.array.two_words_connector'}
    last_word_connector = dotiw.t 'datetime.dotiw.last_word_connector', {default: 'support.array.last_word_connector'}
    sentence = ""
    for value in output
      if sentence isnt ""
        if output.indexOf(value) is output.length - 1
          sentence = "#{sentence}#{last_word_connector}"
        else
          sentence = "#{sentence}#{words_connector}"
      sentence = "#{sentence}#{value}"

    return sentence