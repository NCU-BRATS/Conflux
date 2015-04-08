class UsersController < ApplicationController

  layout 'dashboard'

  before_action :authenticate_user!
  before_action :set_user, only: [:show]

  def index
    @q = User.search(params[:q])
    @users = @q.result.page(params[:page]).per(params[:per])
    respond_with @users
  end

  def show
    respond_with @user
  end


  protected

  def set_user
    @user = User.friendly.find(params[:id])
  end

end
