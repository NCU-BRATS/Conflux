parseJson = (json) ->
  if json instanceof Object then json else {}

$(document).on "ready page:load", () ->
  $('[data-toggle=selectize]').each ()->
    $element = $(@)
    selectizeDefault = unless $element.data('resource-path') then {} else
      preload: 'focus'
      valueField: 'id'
      render:
        option: (item, escape)->
          template = "selectize/#{$element.data('option-tpl') || 'option-default'}"
          HandlebarsTemplates[template](item)
        item: (item, escape)->
          template = "selectize/#{$element.data('item-tpl') || 'item-default'}"
          HandlebarsTemplates[template](item)
      load: (query, callback)->
        queryData = {}
        queryData['q'] = parseJson($element.data('query-param'))
        queryData['q'][$element.data('search-field').join('_or_') + '_cont'] = query
        queryData['per'] = $element.data('query-size')

        $.get($element.data('resource-path')+'.json?', queryData)
        .done (res)-> callback(res)

    settings = $.extend({
      plugins: ['select_add_new']
    }, selectizeDefault, $element.data())
    $element.selectize settings
