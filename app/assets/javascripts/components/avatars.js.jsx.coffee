@Avatar = React.createClass
  propTypes:
    user: React.PropTypes.object.isRequired
    size: React.PropTypes.number
  componentDidMount: ->
    avatarUrl = Gravtastic(@props.user.email, {size: @props.size || 60, default: 'identicon'})
    $(@refs.img.getDOMNode()).attr('src', avatarUrl)
  render: ->
    `<img ref="img"></img>`

@PopupAvatar = React.createClass
  propTypes:
    user: React.PropTypes.object.isRequired

  componentDidMount: ->
    $(@refs.avatar.refs.img.getDOMNode()).popup({content: @props.user.name})
  render: ->
    `<Avatar ref="avatar" {...this.props} />`

@PopupLinkAvatar = React.createClass
  propTypes:
    user: React.PropTypes.object.isRequired

  render: ->
    href = "/users/#{@props.user.slug}"
    `<a className="popup-link-avatar" href={href}>
      <PopupAvatar user={this.props.user} />
    </a>`

@LabelAvatar = React.createClass
  propTypes:
    user: React.PropTypes.object.isRequired

  render: ->
    user = @props.user
    href = "/users/#{ user.slug }"
    `<a className="ui image label" href={ href }>
      <Avatar user={ user } />
      { user.name }
    </a>`
