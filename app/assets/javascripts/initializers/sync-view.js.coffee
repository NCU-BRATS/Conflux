Sync.View.prototype.afterInsert = ->
  $(document).trigger('page:load')
Sync.View.prototype.afterUpdate = ->
  $(document).trigger('page:load')