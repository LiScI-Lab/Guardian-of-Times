# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

updateDateSelectors = (selectors,date) ->
    $(selectors.minutes).val date.getMinutes().toString().padStart(2, "0")
    $(selectors.hours).val date.getHours().toString().padStart(2, "0")
    $(selectors.date).val date.getDate()
    $(selectors.month).val date.getMonth()+1
    $(selectors.year).val date.getFullYear()

$(document).ready ->
  $('button#start-timer').on 'click', ->
    date = new Date()
    obj =
      minutes: 'select#progress_start_5i'
      hours: 'select#progress_start_4i'
      date: 'select#progress_start_3i'
      month: 'select#progress_start_2i'
      year: 'select#progress_start_1i'
    console.log('start clicked')
    updateDateSelectors obj, date
    return false

  $('button#stop-timer').on 'click', ->
    date = new Date()
    obj =
      minutes: 'select#progress_end_5i'
      hours: 'select#progress_end_4i'
      date: 'select#progress_end_3i'
      month: 'select#progress_end_2i'
      year: 'select#progress_end_1i'
    console.log('stop clicked')
    updateDateSelectors obj, date
    return false

  console.log('coffee loaded')
