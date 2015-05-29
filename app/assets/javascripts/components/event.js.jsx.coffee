@EventHelper =
  translateTargetName: (type, target) ->
    switch type
      when "OtherAttachment", "Attachment" then result = "檔案"
      when "Issue"   then result = "任務##{target.sequential_id}"
      when "Sprint"  then result = "戰役###{target.sequential_id}"
      when "Poll"    then result = "投票^#{target.sequential_id}"
      when "Image"   then result = "圖片"
      when "Post"    then result = "貼文"
      when "Snippet" then result = "程式碼"
      when "User"    then result = target.name
      when "Comment"
        return @translateTargetName(target.commentable_type, target.commentable)
    return result += " #{target.title || target.name}"

  translateEvent: (event) ->
    return @translateTargetName(event.target_type, event.target_json)

  targetPath: (type, target) ->
    if type == "Comment"
      result = @targetPath(target.commentable_type, target.commentable)
    else
      result = _.pluralize(type.toLowerCase()) + '/' + (target.sequential_id || target.id)
    return result

@Event = React.createClass
  propTypes:
    event: React.PropTypes.object.isRequired

  render: ->
    switch @props.event.action
      when "created", "uploaded"
        contentPre   = "新增了一個"
      when "closed"
        contentPre   = "關閉了"
      when "reopened"
        contentPre   = "重新開啟了"
      when "joined"
        contentPre   = "將"
        contentPost  = "加入了此專案"
      when "left"
        contentPre   = "將"
        contentPost  = "從此專案移除"
      when "deleted"
        contentPre   = "將"
        contentPost  = "刪除了"
      when "commented"
        contentPre   = "在"
        contentPost  = "留了言:"
        contentBody  = `<div><i className="comment outline icon"></i>{this.props.event.target_json.content}</div>`

    targetPath   = EventHelper.targetPath(@props.event.target_type, @props.event.target_json)
    contentTitle = `<a href={targetPath}>{EventHelper.translateEvent(this.props.event)}</a>`
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
