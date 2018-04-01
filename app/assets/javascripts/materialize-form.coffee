window.materializeForm || (window.materializeForm = {})

materializeForm.init = (elem) ->
  elem || (elem = $('body'))
  materializeForm.initSelect(elem)
  return

materializeForm.initSelect = (elem) ->
  $('select[multiple="multiple"] option[value=""]', elem).attr('disabled', true)
  $('select', elem).formSelect()
  return