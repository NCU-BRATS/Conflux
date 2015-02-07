module ModelIconHelper

  def model_icon_tag(model)
    options = {}
    options[:class] = case model.new
                      when ProjectParticipation
                        'users icon'
                      when Issue
                        'tasks icon'
                      when Sprint
                        'flag icon'
                      when Label
                        'bookmark icon'
                      end

    content_tag('i', '', options)
  end

end
