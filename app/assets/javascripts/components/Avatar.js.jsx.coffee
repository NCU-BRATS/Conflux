@Avatar = React.createClass
  componentDidMount: ->
    avatarUrl = Gravtastic(@props.user.email, {size: 60, default: 'identicon'})
    $(@refs.img.getDOMNode()).attr('src', avatarUrl)
  render: ->
    `<img ref="img"></img>`
