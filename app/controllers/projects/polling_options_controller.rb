class Projects::PollingOptionsController < Projects::ApplicationController

  def update
    @form = PollingOptionOperation::Vote.new(current_user, @poll, @option)
    @form.process
    PrivatePub.publish_to( private_pub_channel, {
         action: 'update',
         target: 'poll',
         data:   private_pub_data
     })
    head :ok
  end

  protected

  def resource
    @poll ||= @project.polls.where(sequential_id: params[:poll_id]).first
    @options ||= @poll.options
    @option  ||= @options.find {|po| po.id == params[:id].to_i}
  end

  def private_pub_channel
    @private_pub_channel ||= "/projects/#{@project.id}/polls/#{@poll.sequential_id}"
  end

  def private_pub_data
    @poll.as_json(include: [ :user, :options, :participations => { include: [ :user ] } ])
  end

end
