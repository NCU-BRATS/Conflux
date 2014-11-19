$(document).on "ready page:load", () ->
  $('img[data-gravatar]').each ()->
    $imgTag = $(@)
    unless $imgTag.attr('src')?
      avatarUrl = Gravtastic $imgTag.data('gravatar'),
        size: $imgTag.data('size')
        default: 'identicon'

      $imgTag.attr('src', avatarUrl)
