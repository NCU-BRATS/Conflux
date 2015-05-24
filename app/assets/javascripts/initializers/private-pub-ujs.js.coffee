$(document).on 'page:change', () ->
  $('[data-private-pub=true]').each ->
    PrivatePub.sign($(@).data())
