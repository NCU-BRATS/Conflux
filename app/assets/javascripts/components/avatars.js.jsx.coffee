@Avatar = React.createClass
  propTypes:
    user: React.PropTypes.object.isRequired
    size: React.PropTypes.number
  componentDidMount: ->
    @refreshAvatar( @props )

  componentWillReceiveProps: (props) ->
    @refreshAvatar( props )

  refreshAvatar: (props) ->
    avatarUrl = Gravtastic(props.user.email, {size: props.size || 60, default: 'identicon'})
    $(@refs.img.getDOMNode()).attr('src', avatarUrl)

  render: ->
    `<img ref="img"></img>`

@AvatarImage = React.createClass
  propTypes:
    user: React.PropTypes.object
    size: React.PropTypes.number

  componentWillReceiveProps: (props) ->
    @refreshPicture(props)

  componentDidMount: ->
    @refreshPicture(@props)

  refreshPicture: (props) ->
    if props.user
      avatarUrl = Gravtastic(props.user.email, {size: props.size || 60, default: 'identicon'})
      $(@refs.img.getDOMNode()).attr('src', avatarUrl)
    else
      $(@refs.img.getDOMNode()).attr('src', '//i.imgur.com/geKmbu9.png')

  render: ->
    `<img className="ui avatar image" ref="img"></img>`

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
    `<a className="ui image label label-avatar" href={ href }>
      <Avatar user={ user } />
      { user.name }
    </a>`
