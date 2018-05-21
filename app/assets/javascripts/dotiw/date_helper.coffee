window.distanceOfTimeInWordsHash = (fromTime, toTime, options = {}) ->
  new TimeHash(null, fromTime, toTime, options).to_hash()

window.distanceOfTime = (seconds, options = {}) ->
  options['includeSeconds'] ||= true
  displayTimeInWords new TimeHash(seconds, null, null, options).to_hash, options

window.distanceOfTimeInWords = (fromTime, toTime = 0, includeSecondsOrOptions = {}, options = {}) ->
  if includeSecondsOrOptions instanceof Object
    options = includeSecondsOrOptions
  else
    options['includeSeconds'] ||= !!include_seconds_or_options

  displayTimeInWords distanceOfTimeInWordsHash(fromTime, toTime, options), options

window.displayTimeInWords = (hash, options) -> hash