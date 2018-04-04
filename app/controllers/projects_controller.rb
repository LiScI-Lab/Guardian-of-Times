class ProjectsController < ApplicationController
  layout 'project'

  load_and_authorize_resource

  def show
    if can? :dashboard, @project
      redirect_to dashboard_project_path(@project)
    else
      redirect_to dashboard_project_member_path(@project, @current_member)
    end
  end

  def dashboard
  end

  def new
  end

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

  def join
    @current_member.status = :joined
    if @current_member.save
      flash[:success] = "Successfully joined #{@project.name}"
      if @current_member.owner?
        redirect_to dashboard_project_path(@project)
      else
        redirect_to dashboard_project_member_path(@project, @current_member)
      end
    else
    end
  end

  private
  def project_params
    params.require(:project).permit([:name, :description])
  end
end
