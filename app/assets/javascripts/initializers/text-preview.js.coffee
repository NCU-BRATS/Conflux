$(document).on 'ready page:load', () ->

  $('[data-preview]').each ()->

    $element = $(@)
    return if $element.data('preview-binded')

    name = $element.data('preview')

    $element.on 'click', () ->
      $("##{name}_preview_field").html('
        <div class="ui active inverted dimmer">
          <div class="ui text loader">Loading</div>
        </div>')
      $.ajax
        url: '/text/preview'
        type: 'put'
        data:
          name: name
          content: $("#"+"#{name}_post_field").val()

    $element.data('preview-binded', true)
