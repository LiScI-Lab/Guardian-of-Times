class Project::ExportController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource :progress, through: :project

  #TODO: current month as default ; use max_hours from project

  def index
    #setup values for month picker
    @month_with_index = Date::MONTHNAMES.each_with_index.collect{|m,i| [m,i]}
    @current_month = @month_with_index[DateTime.now.month]
  end

  def create
    require 'project/work_duration'
    # raise "dump"
    month = Date.new(DateTime.now.year, export_params[:month].to_i)
    progresses_current_month = @current_member.progresses.in_month(month).all
    durations = progresses_current_month.map { |p|  WorkDuration.new(p.start, p.start,p.end) }
    @normalized_progresses = durations
    render 'report'
    # render plain: export_params
  end

  private
  def export_params
    params.require(:export_options).permit(:month,:max_hours)
  end
end
