@Avatar = React.createClass
  propTypes:
    user: React.PropTypes.object.isRequired
    size: React.PropTypes.number
  componentDidMount: ->
    avatarUrl = Gravtastic(@props.user.email, {size: @props.size || 60, default: 'identicon'})
    $(@refs.img.getDOMNode()).attr('src', avatarUrl)
  render: ->
    `<img ref="img"></img>`
