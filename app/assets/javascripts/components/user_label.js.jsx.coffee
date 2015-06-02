@UserBigLabel = React.createClass
  propTypes:
    user: React.PropTypes.object.isRequired

  render: ->
    user = @props.user
    `<div>
        <div style={ { "float" : "left" } }>
            <Avatar user={ user } size={40} />
        </div>
        <div style={ { "paddingLeft" : "50px" } }>
            <strong>
                { user.name }
            </strong>
            <div className="text-muted">
                { user.email }
            </div>
        </div>
    </div>`

@UserSmallLabel = React.createClass
  propTypes:
    user: React.PropTypes.object.isRequired

  render: ->
    user = @props.user
    userHref = "/users/#{ user.slug }"
    `<a className="ui image label" href={ userHref }>
        <Avatar user={ user } />
        { user.name }
    </a>`

@UserImageSmallLabel = React.createClass
  propTypes:
    user: React.PropTypes.object.isRequired

  render: ->
    user = @props.user
    userHref = "/users/#{ user.slug }"
    `<a className="user-small-image" href={ userHref }>
        <Avatar user={ user } />
    </a>`