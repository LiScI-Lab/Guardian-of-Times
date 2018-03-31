class ProjectsController < ApplicationController
  load_and_authorize_resource

  def show; end
  def new; end

  def create
    if @project.save
      flash[:notice] = "Project successfully created"
      redirect_to @project
    else
      render 'new'
    end
  end

  def index
    #TODO: use projects from db !
    @projects = Array.new(5,Project.new(id: -1, name: "test proj", description: "an awesome testproj"))
  end

  private
  def project_params
    params.require(:project).permit([:name, :description])
  end
end
