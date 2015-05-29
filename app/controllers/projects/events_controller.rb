class Projects::EventsController < Projects::ApplicationController

  def index
    params.reverse_merge!({f: {comment: true, issue: true, poll: true, user: true, attachment: true}, q:{}})

    types =  []
    types += ['Comment']           if params[:f][:comment] == 'true'
    types += ['Issue', 'Sprint']   if params[:f][:issue] == 'true'
    types += ['Poll']              if params[:f][:poll] == 'true'
    types += ['User']              if params[:f][:user] == 'true'
    types += Attachment.subclasses if params[:f][:attachment] == 'true'

    @events = @project.events.includes(:author).order('id DESC').limit(15)
                             .search(params[:q].merge({target_type_in: types})).result

    respond_with @events
  end

  def model
    :event
  end

end
