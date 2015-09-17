@TranslateHelper =
  translateTargetName: (type, target) ->
    switch type
      when "OtherAttachment", "Attachment" then result = "檔案"
      when "Issue"   then result = "任務##{target.sequential_id}"
      when "Sprint"  then result = "戰役###{target.sequential_id}"
      when "Poll"    then result = "投票^#{target.sequential_id}"
      when "Image"   then result = "圖片"
      when "Post"    then result = "貼文"
      when "Snippet" then result = "程式碼"
      when "Channel" then result = "頻道"
      when "User"
        return `<span className="member"><Avatar user={target} />{target.name}</span>`
      when "Comment"
        return @translateTargetName(target.commentable_type, target.commentable)
    return result += " #{target.title || target.name}"

  translate: (t) ->
    return @translateTargetName(t.target_type, t.target_json)

  targetPath: (type, target) ->
    if type == "Comment"
      result = @targetPath(target.commentable_type, target.commentable)
    else if type == "Sprint"
      result = 'kanban?sprint_sequential_id='  + (target.sequential_id)
    else if type == "Issue"
      result = 'kanban?sprint_sequential_id='  + (target.sprint_id) + '&issue_sequential_id=' + (target.sequential_id)
    else if type == "User"
      result = "../../users/#{target.slug}"
    else if type == "OtherAttachment" || type == 'Image'
      result = 'attachments/' + (target.sequential_id || target.id)
    else
      result = _.pluralize(type.toLowerCase()) + '/' + (target.sequential_id || target.id)
    return result

  translateAction: (t) ->
    switch t.action
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
      when "mention"
        contentPre   = "在"
        contentPost  = "提到你"
      when "commented"
        contentPre   = "在"
        contentPost  = "留了言:"
        contentBody  = `<div><i className="comment outline icon"></i>{t.target_json.content}</div>`

    return {contentPre, contentPost, contentBody}

  noticePath: (t) ->
    return "/projects/#{t.project.slug}/#{@targetPath(t.target_type, t.target_json)}"
