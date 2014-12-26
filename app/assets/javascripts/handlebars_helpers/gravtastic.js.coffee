Handlebars.registerHelper 'gravtastic', (email, size) ->
  avatarUrl = Gravtastic email,
    size: size * 2
    default: 'identicon'

  return new Handlebars.SafeString('<img src="'+avatarUrl+'" height="'+size+'" width="'+size+'" ></img>')
