Sync.View.prototype.afterInsert = ->
  $(document).trigger('page:load')
