class ProfilesController < ApplicationController

  layout :determine_layout

  def determine_layout
    request.format.html? ? 'profile' : 'application'
  end

end
