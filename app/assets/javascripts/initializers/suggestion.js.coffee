$(document).on "ready page:load", () ->
  $('[data-toggle=suggestion]').each ()->
    $element = $(@)
    $element.atwho
      at: '@'
      displayTpl: "<li>${name}</li>"
      insertTpl: "${atwho-at}${name}",

    $element.atwho
      at: '#'
      displayTpl: "<li>${title}</li>"
      insertTpl: "${atwho-at}${id}",

    $suggestionsPath = $element.attr('data-suggestions-path')

    $.getJSON($suggestionsPath).done (data) ->
      $element.atwho 'load', '@', data.members
      $element.atwho 'load', '#', data.issues
