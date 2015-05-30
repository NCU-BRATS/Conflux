@Event = React.createClass
  propTypes:
    event: React.PropTypes.object.isRequired

  render: ->
    {contentPre, contentPost, contentBody} = TranslateHelper.translateAction(@props.event)
    targetPath   = TranslateHelper.targetPath(@props.event.target_type, @props.event.target_json)
    contentTitle = `<a href={targetPath}>{TranslateHelper.translate(this.props.event)}</a>`
    userPath     = "/users/#{@props.event.author.slug}"
    time         = moment(new Date(@props.event.created_at)).fromNow()

    `<div className="event card" onClick={this.handleOnClick}>
      <div className="thumb">
        <Avatar user={this.props.event.author} />
      </div>
      <div className="content">
        <div className="header">
          <div className="title">
            <a className="bold link" href={userPath}>{this.props.event.author.name}</a>
            {contentPre}{contentTitle}{contentPost}
          </div>
          <span className="time">{time}</span>
        </div>
        <div className="body">
          {contentBody}
        </div>
      </div>
    </div>`
