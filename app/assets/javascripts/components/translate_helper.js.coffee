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
      when "User"    then result = target.name
      when "Comment"
        return @translateTargetName(target.commentable_type, target.commentable)
    return result += " #{target.title || target.name}"

  translate: (t) ->
    return @translateTargetName(t.target_type, t.target_json)

  targetPath: (type, target) ->
    if type == "Comment"
      result = @targetPath(target.commentable_type, target.commentable)
    else
      result = _.pluralize(type.toLowerCase()) + '/' + (target.sequential_id || target.id)
    return result

  noticePath: (t) ->
    return "/projects/#{t.project.slug}/#{@targetPath(t.target_type, t.target_json)}"
