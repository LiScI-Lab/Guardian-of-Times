class ProjectsController < ApplicationController
  def show
  end

  def new
    puts 'User', @current_user.inspect
    @project = Project.new
  end
end
