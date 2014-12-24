$(document).on 'ready page:load update_time', () ->
  timeUpate()

setInterval( ()->
  $(document).trigger('update_time')
, 1000*60 )

timeUpate = () ->
  $('span[data-moment]').each ()->
    $timeTag = $(@)
    time = $timeTag.data('moment')
    if $timeTag.data('type')?
      switch $timeTag.data('type')
        when 'absolute'
          $timeTag.text( moment( new Date(time) ).format( $timeTag.data('format') ) )
        when 'relative'
          $timeTag.text( moment( new Date(time) ).fromNow() )

