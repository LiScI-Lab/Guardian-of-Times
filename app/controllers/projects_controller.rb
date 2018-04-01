class ProjectsController < ApplicationController
  layout 'project'

  load_and_authorize_resource

  def show
    start_time = Faker::Time.between(2.days.ago, Date.today, :morning)
    end_time = Faker::Time.between(start_time, Date.today, :evening)
    @progresses = Array.new(5, Project::Progress.new(start: start_time, end: end_time))
  end
  def new; end

  def create
    @project.members.new user: @current_user, role: :owner
    if @project.save
      flash[:success] = "Project successfully created"
      redirect_to @project
    else
      render 'new'
    end
  end

  def index
    @projects = @current_user.involved_projects.kept
  end

  def invited
    @projects = @current_user.invited_projects.kept
  end

  def owner
    @projects = @current_user.own_projects.kept

  end


  private
  def project_params
    params.require(:project).permit([:name, :description])
  end
end
