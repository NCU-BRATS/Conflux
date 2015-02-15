$('#message_content_post_field').val('').css('height','3em')
$messageContainer = $('#message_container')
$messageContainer.scrollTop($messageContainer[0].scrollHeight - $messageContainer.height()) # navigate to bottom
$messageContainer.perfectScrollbar('update')
