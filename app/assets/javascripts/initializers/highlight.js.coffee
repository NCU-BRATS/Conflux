$(document).on "ready page:load", () ->
  $('pre[lang] code').each (i, block) ->
    $code = $(@)
    $pre = $code.closest('pre')
    lang = $pre.attr('lang')
    lang = 'coffee' if lang == 'yml' || lang == 'yaml'
    $code.addClass(lang)
    $pre.addClass('hljs') unless lang == 'no-highlight'
    hljs.highlightBlock(block)
