module Projects

  class IssuesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_issue, only: [ :show, :edit, :update, :destroy ]
    # before_action :authorize_issue, only: [ :new, :create, :edit, :update, :destroy ]

    def index
      @query  = Issue.search( params[:q] )
      @issues = @query.result.page( params[:page] ).per( params[:per] )
      respond_with @project, @issue
    end

    def show
      respond_with @project, @issue
    end

    def new
      @issue = @project.issues.build
      @issue.comments.build
      authorize @issue
      respond_with @project, @issue
    end

    def edit
      respond_with @project, @issue
    end

    def create
      @issue = @project.issues.build( issue_params )
      @issue.user = current_user
      flash[:notice] = "已成功創建#{ Issue.model_name.human }" if @issue.save
      respond_with @project, @issue
    end

    def update
      flash[:notice] = "已成功修改#{ Issue.model_name.human }" if @issue.update( issue_params )
      respond_with @project, @issue
    end

    private

    def set_issue
      @issue = @project.issues.includes( :user ).find_by_sequential_id( params[:id] )
    end

    def issue_params
      params.require(:issue).permit( :title, :begin_at, :due_at, comments_attributes: [ :user_id, :content ] )
    end

    def authorize_issue
      authorize @issue
    end

  end

end