parseJson = (json) ->
  if json instanceof Object then json else {}

$(document).on "ready page:load", () ->
  $('[data-toggle=selectize]').each ()->
    $element = $(@)
    selectizeDefault = unless $element.data('resource-path') then {} else
      preload: true
      render:
        option: (item, escape)->
          tpl = '<div><div>' + escape(item[$element.data('label-field')]) + '</div>'
          if item[$element.data('desc-field')]
            tpl += ('<div class="text-muted">' + escape(item[$element.data('desc-field')]) + '</div>')
          return tpl + '</div>'
      load: (query, callback)->
        queryData = {}
        queryData['q'] = parseJson($element.data('query-param'))
        queryData['q'][$element.data('query-key')] = query
        queryData['per'] = $element.data('query-size')

        $.get($element.data('resource-path')+'.json?', queryData)
        .done (res)-> callback(res)

    settings = $.extend({}, $element.data(), selectizeDefault)
    $element.selectize settings
