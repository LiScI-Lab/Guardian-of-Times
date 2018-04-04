class Project::Member::ProgressesController < ApplicationController
  layout 'project'

  load_and_authorize_resource :project
  load_and_authorize_resource :member, class: Project::Member
  load_and_authorize_resource :progress, through: :project, class: Project::Progress

  def index
    @progresses = @progresses.where(project_members_progresses: {project_member_id: @member})
    @progress = Project::Progress.new(start: DateTime.now)
  end

  def create
    @progress.members << @member
    if @progress.save
      flash[:success] = "Progress successfully started"
      redirect_to project_member_progresses_path(@project, @member)
    else
      flash[:error] = "Progress not created"
      render 'index'
    end
  end

  def stop
    @progress.end = DateTime.now
    if @progress.save
      flash[:success] = "Progress successfully stopped"
    else
      flash[:error] = "Progress not stopped"
    end
    redirect_to project_member_progresses_path(@project, @member)
  end

  private
  def progress_params
    params.require(:progress).permit([:description])
  end
end
