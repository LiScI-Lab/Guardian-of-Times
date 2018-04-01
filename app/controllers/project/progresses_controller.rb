class Project::ProgressesController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource :progress, through: :project

  def index
  end

  def create
    @progress.members << @current_member
    if @progress.save
      flash[:success] = "Progress successfully started"
    else
      flash[:error] = "Progress not created"
    end
    redirect_to @project
  end

  def stop
    @progress.end = DateTime.now
    if @progress.save
      flash[:success] = "Progress successfully stopped"
    else
      flash[:error] = "Progress not stopped"
    end
    redirect_to @project
  end

  private
  def progress_params
    params.require(:progress).permit([:start, :end, :description])
  end
end
