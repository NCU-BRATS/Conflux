class Projects::PollingOptionsController < Projects::ApplicationController

  enable_sync only: [:update]

  def update
    @form = PollingOptionOperation::Vote.new(current_user, @poll, @option)
    flash.now[:alert] = t('poll.alert') unless @form.process
    respond_with @project, @form
  end

  protected

  def resource
    @poll ||= @project.polls.where(sequential_id: params[:poll_id]).first
    @options ||= @poll.options
    @option  ||= @options.find {|po| po.id == params[:id].to_i}
  end

end
