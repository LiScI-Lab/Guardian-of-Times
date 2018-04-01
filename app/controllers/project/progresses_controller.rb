class Project::ProgressesController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def new
    @project = Project.find(params[:project_id])
    @progress = Project::Progress.new(start: DateTime.now, end: DateTime.now)
  end
  def create
    @project = Project.find(params[:project_id])
    @progress.project_id = @project.id
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
