$(document).on "ready page:load", () ->
  $('[data-toggle=datetime-picker]').each () ->
    $input   = $(@)
    picktime = $input.attr('type') == 'datetime'
    format   = if picktime then 'YYYY-MM-DD HH:mm' else 'YYYY-MM-DD'

    $input.val(moment($input.val()).format(format)) if $input.val() != ''

    $input.datetimepicker
      language: 'zh-tw'
      pickTime: picktime
      pick12HourFormat: false
      format: format
