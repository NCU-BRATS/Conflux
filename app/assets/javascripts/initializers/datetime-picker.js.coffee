$(document).on "ready page:load", () ->
  $('[data-toggle=datetime-picker]').each ()->
    $input = $(@)
    picktime = $input.attr('type') == 'datetime'
    $input.datetimepicker
      language: 'zh-tw'
      pickTime: picktime
      pick12HourFormat: false
      format: if picktime then 'YYYY-MM-DD HH:mm' else 'YYYY-MM-DD'
