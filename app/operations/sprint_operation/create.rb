module SprintOperation
  class Create < BaseForm

    def initialize(current_user, project)
      @current_user = current_user
      @project      = project
      super(Sprint.new)
    end

    def process(params)
      sprint_params = sprint_params(params)
      if validate(sprint_params.except(:issue_ids)) && sync
        @model.user   = @current_user
        @model.project = @project
        @model.statuses = [{id: 1,name: 'backlog'}, {id: 2,name: 'done'}]
        if @model.save
          @model.update_attributes(issue_ids: sprint_params[:issue_ids])
          ParticipationOperation::Create.new(@current_user, @model).process
          BroadcastService.fire(:on_sprint_created, @model, @current_user)
        end
      end
    end
  end
end
