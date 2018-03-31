class ProjectsController < ApplicationController
  layout 'project'

  load_and_authorize_resource

  def show; end
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
