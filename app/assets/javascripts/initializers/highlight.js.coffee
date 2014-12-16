$(document).on "ready page:load", () ->
  $('pre[lang] code').each (i, block) ->
    $code = $(@)
    $pre = $code.closest('pre')
    lang = $pre.attr('lang')
    $code.addClass(lang)
    $pre.addClass('hljs') unless lang == 'no-highlight'
    hljs.highlightBlock(block)
