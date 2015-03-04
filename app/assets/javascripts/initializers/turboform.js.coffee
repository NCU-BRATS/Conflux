$(document).on 'submit', 'form[data-turboform]', (e) ->
  Turbolinks.visit(@action + '?' + $(@).serialize())
  false
