Sync.View.prototype.afterInsert = ->
  $(document).trigger('page:load')
  @$el.addClass('sync-highlight')
Sync.View.prototype.afterUpdate = ->
  $(document).trigger('page:load')
  @$el.addClass('sync-highlight')
