Selectize.define 'select_add_new', (options)->
  resourcePath = @.settings.resourcePath
  addNew = @.settings.addNew
  return if (!resourcePath? || !addNew?)

  $link = $('<div data-selectable><a target="_blank" href="'+resourcePath+'/new">新增</a></div>')

  self = @
  self.refreshOptions = (()->
    original = self.refreshOptions
    return ()->
      res = original.apply(@, arguments)

      if (@.currentResults.total == 0)
        @.$dropdown_content.prepend($link)

        @.isOpen = true;
        @.$dropdown.css({visibility: 'hidden', display: 'block'});
        @.positionDropdown();
        @.$dropdown.css({visibility: 'visible'});

      return res
  )()

  self.close = (() ->
    original = self.close
    return ()->
      @.loadedSearches = {} # clear search cache
      return original.apply(@, arguments)
  )()
