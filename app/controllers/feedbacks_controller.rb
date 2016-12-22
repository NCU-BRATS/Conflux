class FeedbacksController < ApplicationController

  before_action :authenticate_user!

  def create
    feedback = current_user.feedbacks.build
    feedback.body = params[:body]
    feedback.save
    respond_with(feedback)
  end

end
