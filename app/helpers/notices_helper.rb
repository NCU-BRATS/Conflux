module NoticesHelper

  def notice_action_name(notice)
    target = if notice.target_type
               notice.target_type.titleize.downcase
             else
               'project'
             end
    action_name notice, I18n.t(['project', target].join('.')+'s')
  end

  def action_name (notice, target)
    if notice.closed?
      I18n.t('action.target.close', :target => target)
    elsif notice.mention?
      I18n.t('action.target.mention')
    elsif notice.uploaded?
      I18n.t('action.target.upload' , :target => target)
    elsif notice.deleted?
      I18n.t('action.target.delete' , :target => target)
    elsif notice.comment?
      I18n.t('action.target.write', :target => target)
    else
      I18n.t('action.target.open', :target => target)
    end
  end

  def event_icon_tag(type)
    options = {}
    options[:class] = case type
                        when 'all'
                          'announcement icon'
                        when 'Comment'
                          'comments icon'
                        when 'Issue'
                          'tasks icon'
                        when 'Attachment'
                          'file icon'
                        when 'User'
                          'users icon'
                      end

    content_tag('i', '', options)
  end

end
