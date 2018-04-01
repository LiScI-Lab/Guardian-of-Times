window.materializeForm || (window.materializeForm = {})

materializeForm.init = (elem) ->
  elem || (elem = $('body'))
  materializeForm.initDate(elem)
  materializeForm.initSelect(elem)
  materializeForm.initCheckbox(elem)
  return

materializeForm.initDate = (elem) ->
  $('input.datepicker', elem).datepicker()
  return

materializeForm.initSelect = (elem) ->
  $('select[multiple="multiple"] option[value=""]', elem).attr('disabled', true)
  $('select', elem).formSelect()
  return

materializeForm.initCheckbox = (elem) ->
  #$('input[type=checkbox]', elem).addClass('filled-in')
  return
