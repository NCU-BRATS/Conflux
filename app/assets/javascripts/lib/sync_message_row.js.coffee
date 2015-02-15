class Sync.MessageRow extends Sync.View

  afterInsert: ->
    super()
    $prev = @$el.prev().prev().prev()
    if $prev.data('user') == @$el.data('user')
      prevTime = moment($prev.find('.time').data('moment'))
      time = moment(@$el.find('.time').data('moment'))
      @$el.addClass('inline-message') if time - prevTime < 300000

    $messageContainer = $('#message_container')
    scrollBottom   = $messageContainer[0].scrollHeight - $messageContainer.height()
    scrollPosition = $messageContainer.scrollTop()
    if scrollBottom - scrollPosition < 100
      $messageContainer.scrollTop(scrollBottom)
      $messageContainer.perfectScrollbar('update')

  beforeRemove: ->
    $prev = @$el.prev().prev().prev()
    if $prev.data('user') != @$el.data('user')
      $next = @$el.next().next().next()
      $next.removeClass('inline-message')
    super()
