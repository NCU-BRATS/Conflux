class DashboardController < ApplicationController
  before_action :authenticate_user!
  layout :determine_layout

  def determine_layout
    'dashboard'
  end

  def show

  end
end