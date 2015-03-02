module EventsHelper

  def event_action_name(event)
    target = if event.target_type
               event.target_type.titleize.downcase
             else
               'project'
             end
    action_name event, I18n.t(['project', target].join('.')+'s')
  end

  def action_name (event, target)
    if event.closed?
      I18n.t('action.target.close', :target => target)
    elsif event.joined?
      I18n.t('action.target.join', :target => target)
    elsif event.left?
      I18n.t('action.target.left', :target => target)
    elsif event.uploaded?
      I18n.t('action.target.upload', :target => target)
    elsif event.comment?
      I18n.t('action.target.write', :target => target)
    else
      I18n.t('action.target.open', :target => target)
    end
  end

  def parse_json_to_object (json, class_name)
    class_name.constantize.new (json)
  end

end