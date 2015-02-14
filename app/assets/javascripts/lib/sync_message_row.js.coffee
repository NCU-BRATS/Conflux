class Sync.MessageRow extends Sync.View

  afterInsert: ->
    super()
    $prev = @$el.prev().prev().prev()
    if $prev.data('user') == @$el.data('user')
      @$el.addClass('inline-message')

  beforeRemove: ->
    $prev = @$el.prev().prev().prev()
    if $prev.data('user') != @$el.data('user')
      $next = @$el.next().next().next()
      $next.removeClass('inline-message')
    super()
