@Notice = React.createClass
  propTypes:
    notice:        React.PropTypes.object.isRequired
    openNotice:    React.PropTypes.func.isRequired
    archiveNotice: React.PropTypes.func.isRequired

  handleOnClick: (e) ->
    e.stopPropagation()
    @props.openNotice(@props.notice)

  render: ->
    contentTitle = `<strong>{TranslateHelper.translate(this.props.notice)}</strong>`
    switch @props.notice.action
      when "created", "uploaded"
        contentPre   = "新增了一個 "
      when "closed"
        contentPre   = "關閉了 "
      when "reopened"
        contentPre   = "重新開啟了 "
      when "commented"
        contentPre   = "在 "
        contentPost  = " 留了言: "
        contentBody  = @props.notice.target_json.content

    classStr = "notice card #{@props.notice.mode}"

    `<div className={classStr} onClick={this.handleOnClick}>
      <div className="thumb">
        <Avatar user={this.props.notice.author} />
      </div>
      <div className="content">
        <NoticeHeader i={this.props.i} notice={this.props.notice} archiveNotice={this.props.archiveNotice} />
        <div className="body">
          {contentPre}{contentTitle}{contentPost}{contentBody}
        </div>
      </div>
    </div>`

@NoticeHeader = React.createClass
  handleOnClose: (e) ->
    e.stopPropagation()
    @props.archiveNotice(@props.notice, @props.i)

  render: ->
    userPath    = "/users/#{@props.notice.author.slug}"
    projectPath = "/projects/#{@props.notice.project.slug}"
    time        = moment(new Date(@props.notice.created_at)).fromNow()
    closeBtn    = `<i className="close icon" onClick={this.handleOnClose}></i>` if @props.notice.state == 'unseal'

    `<div className="header">
      <a className="bold black link" href={userPath}>{this.props.notice.author.name}</a>
      <span className="time">{time}</span>
      {closeBtn}
      <a href={projectPath} className="ui mini label project">{this.props.notice.project.name}</a>
    </div>`
