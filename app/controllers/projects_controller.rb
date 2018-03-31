class ProjectsController < ApplicationController
  load_and_authorize_resource
  def index
    #TODO: use projects from db !
    @projects = Array.new(5,Project.new(id: -1, name: "test proj", description: "an awesome testproj"))
  end
  def show
  end

  def new
    puts 'User', @current_user.inspect
    @project = Project.new
  end
end
