$(document).on 'ready page:load', () ->

  $('[data-editable]').each ()->

    $element = $(@)
    return if $element.data('editable-binded')

    name = $element.data('editable')
    $editForm  = $("#editable_#{name}_form")
    $content   = $("#editable_#{name}")
    $cancelBtn = $("#editable_#{name}_cancel")

    $editForm.hide()
    $element.on 'click', () ->
      $editForm.show()
      $content.hide()
    $cancelBtn.on 'click', () ->
      $editForm.hide()
      $content.show()

    $element.data('editable-binded', true )
