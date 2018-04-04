class Project::MembersController < ApplicationController
  layout 'project'

  load_and_authorize_resource :project
  load_and_authorize_resource :member, through: :project

  def index
  end

  def show
    redirect_to dashboard_project_member_path(@project, @member)
  end

  def dashboard
  end

  def new
  end

  def invite
    invite_params[:users].reject { |c| c.empty? }.each do |id|
      @project.members.find_or_initialize_by user: User.find(id)
    end
    if @project.save
      flash[:success] = "Users are invited!"
    else
      flash[:error] = "Something went wrong"
    end
    redirect_to project_members_path(@project)
  end

  private
  def invite_params
    params.require(:invitations).permit(users: [])
  end
end