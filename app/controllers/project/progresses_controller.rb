class Project::ProgressesController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def new
    @progress = Project::Progress.new(start: DateTime.now, end: DateTime.now)
  end
  def create
    #TODO: render errors in view
    @project = Project.find(params[:project_id])
    @progress.project_id = @project.id
    @progress.members.new(user: @current_user)
    @progress.tags = []
    if @progress.save
      flash[:success] = "Progress successfully created"
      redirect_to @project
    else
      render 'new'
    end
  end

  private
  def progress_params
    params.require(:progress).permit([:start, :end, :description])
  end
end
