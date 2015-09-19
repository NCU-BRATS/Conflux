module SprintOperation
  class Update < BaseForm

    def initialize(current_user, project, sprint)
      @current_user = current_user
      @project      = project

      super(sprint)
    end

    def process(params)
      if validate(sprint_params(params)) && sync
        if @model.statuses.length >= 2 &&
           @model.issues.where( 'status NOT IN (?)', @model.statuses.map{ |s| s['id'].to_s } ).count == 0 &&
           @model.statuses[-1]['id'] == 2
          @model.save
        end
      end
    end

  end
end
