class ProjectsController < ApplicationController
  load_and_authorize_resource
  def index
  end
  def show
  end

  def new
    puts 'User', @current_user.inspect
    @project = Project.new
  end
end
