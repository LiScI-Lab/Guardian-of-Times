class Project::Member::ProgressesController < ApplicationController
  layout 'project'

  load_and_authorize_resource :project
  load_and_authorize_resource :member, class: Project::Member
  load_and_authorize_resource :progress, through: :project, class: Project::Progress

  #TODO: reuse form for new & edit; currently the partial is not found if i try to include it?.
  #TODO: use materializecss datepicker instead of input field ??

  def index
    @progresses = @progresses.where(project_members_progresses: {project_member_id: @member})
    @progress = Project::Progress.new(start: DateTime.now)
  end

  def new
    @progress = Project::Progress.new
  end
  def create
    @progress.members << @member
    if @progress.save
      flash[:success] = "Progress successfully added"
      redirect_to project_member_progresses_path(@project, @member)
    else
      flash[:error] = "Progress not created"
      render 'new'
    end
  end

  def update
    if @progress.update progress_params
      flash[:success] = "Progress successfully updated"
      redirect_to project_member_progresses_path(@project, @member)
    else
      flash[:error] = "Progress not updated"
      render 'index'
    end
  end

  def start
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

  def destroy
    if @progress.discard
      flash[:success] = "Progress successfully discarded"
    else
      flash[:error] = "Progress not discarded"
    end
    redirect_to project_member_progresses_path(@project, @member)
  end

  def restore
    if @progress.undiscard
      flash[:success] = "Progress successfully undiscarded"
    else
      flash[:error] = "Progress not undiscarded"
    end
    redirect_to project_member_progresses_path(@project, @member)
  end

  private
  def progress_params
    params.require(:progress).permit([:start, :end, :description])
  end
end
