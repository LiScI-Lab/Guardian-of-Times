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

class TimeHash
  @MINUTE = 60
  @HOUR = @MINUTE * 60
  @DAY = @HOUR * 24
  @WEEK = @DAY * 7
  @FOURWEEKS = @WEEK * 4

  @TIME_FRACTIONS = ['seconds', 'minutes', 'hours', 'days', 'weeks', 'months', 'years']
  constructor: (distance, from_time = null, to_time = null, options = {}) ->
    @output = {}
    @options = options
    @distance = distance
    @from_time = new Date(from_time || Date.now())
    if(to_time?)
      @to_time = new Date(to_time)
      @to_time_not_given = false
    else
      if @distance instanceof Date
        @to_time = new Date(@from_time + @distance)
        @distance = Math.floor(@distance / 1000)
      else
        @to_time = new Date(@from_time.getTime() + @distance * 1000)
      @to_time_not_given = true
    @smallest = new Date(Math.min(@from_time, @to_time))
    @largest = new Date(Math.max(@from_time, @to_time))

    @distance ||= (@largest - @smallest) / 1000

    @build_time_hash()

  to_hash: () -> @output

  build_time_hash: () ->
    if @options['accumulate_on']? or @options['accumulateOn']?
      accumulate_on = @options['accumulate_on'] || @options['accumulateOn']
      delete @options['accumulate_on']
      delete @options['accumulateOn']
      if accumulate_on == 'years'
        return @build_time_hash()
      start = TimeHash.TIME_FRACTIONS.indexOf(accumulate_on)
      for i in [start, 0]
        @["build_#{TimeHash.TIME_FRACTIONS[i]}"]()
    else
      while @distance > 0
        if @distance < TimeHash.MINUTE
          @build_seconds()
        else if @distance < TimeHash.HOUR
          @build_minutes()
        else if @distance < TimeHash.DAY
          @build_hours()
        else if @distance < TimeHash.WEEK
          @build_days()
        else if @distance < TimeHash.FOURWEEKS
          @build_weeks()
        else
          @build_years_months_weeks_days()
    @output

  build_seconds: () ->
    @output['seconds'] = Math.floor @distance
    @distance = 0

  build_minutes: () ->
    @output['minutes'] = Math.floor(@distance / TimeHash.MINUTE)
    @distance = @distance % TimeHash.MINUTE

  build_hours: () ->
    @output['hours'] = Math.floor(@distance / TimeHash.HOUR)
    @distance = @distance % TimeHash.HOUR

  build_days: () ->
    if not @output['days']?
      @output['days'] = Math.floor(@distance / TimeHash.DAY)
      @distance = @distance % TimeHash.DAY

  build_weeks: () ->
    if not @output['weeks']?
      @output['weeks'] = Math.floor(@distance / TimeHash.WEEK)
      @distance = @distance % TimeHash.WEEK

  build_months: () ->
    @build_years_months_weeks_days

    years = @output['years']
    delete @output['years']
    @output['months'] += (years * 12) if years > 0

  build_years_months_weeks_days: () ->
    months = (@largest.getFullYear() - @smallest.getFullYear()) * 12 + (@largest.getMonth() - @smallest.getMonth())
    years = Math.floor(months / 12)
    months = months % 12

    days = @largest.getDate() - @smallest.getDate()

    weeks = Math.floor(days / 7)
    days = days % 7

    days -= 1 if @largest.getHours() < @smallest.getHours()

    if days < 0
      weeks -= 1
      days += 7

    if weeks < 0
      months -= 1
      d = new Date(@largest)
      d.setMonth(d.getMonth() - 1)
      days_in_month = new Date(d.getFullYear(), d.getMonth(), 0).getDate()
      weeks += Math.floor(days_in_month / 7)
      days += days_in_month % 7
      if days >= 7
        days -= 7
        weeks += 1

    if months < 0
      years -= 1
      months += 12

    @output['years'] = years
    @output['months'] = months
    @output['weeks'] = weeks
    @output['days'] = days

    total_days = Math.abs(@distance) / TimeHash.DAY
    @distance = Math.abs(@distance) % TimeHash.DAY

    [total_days, @distance]

window.dotiw.TimeHash = TimeHash