$(document).on 'ready page:load', () ->

  $('[data-editable]').each ()->

    $element = $(@)
    name = $element.data('editable')
    $form    = $("#editable_#{name}_form")
    $content = $("#editable_#{name}")
    $cancelBtn = $("#editable_#{name}_cancel")

    $form.hide()
    $element.on 'click', () ->
      $form.show()
      $content.hide()
    $cancelBtn.on 'click', () ->
      $form.hide()
      $content.show()