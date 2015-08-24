module PollOperation
  class Create < BaseForm

    def initialize(current_user, project)
      @current_user = current_user
      @project      = project
      poll          = Poll.new(options: [PollingOption.new])
      super(poll)
    end

    def process(params)
      params = poll_params(params)

      params[:options_attributes].each do |k, v|
        v['title'] = 1 if v['_destroy'] == '1' # hack to pass validation for options will be deleted.
      end

      save do |hash|
        @model.user    = @current_user
        @model.project = @project
        if @model.save
          ParticipationOperation::Create.new(@current_user, @model).process
          BroadcastService.fire(:on_poll_created, @model, @current_user)
        end
      end if validate(params) && sync
    end
  end
end
