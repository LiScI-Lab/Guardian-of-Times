class Project::ExportController < ApplicationController
  layout 'project'
  load_and_authorize_resource :project
  authorize_resource :export, class: false

  #TODO:  use max_hours from project ; german month names ! ; add total hours below the table

  def index
    #setup values for month picker
    @month_with_index = Date::MONTHNAMES.each_with_index.collect{|m,i| [m,i]}
    @current_month = @month_with_index[DateTime.now.month]
  end

  def create
    @debug_pdf = params[:debug].present? || export_params[:format] == :html.to_s
    @report_month = Date.new(DateTime.now.year, export_params[:month].to_i)
    progresses_current_month = @current_member.progresses.in_month(@report_month).all
    durations = progresses_current_month
                  .sort_by { |p| p.start }
                  .map { |p|
      Project::WorkDuration.new(p.start,p.start,p.end)
    }
                  .group_by { |p| p.date.to_date }
                  .map { |date,values|
      values.reduce { |acc,p|
        acc.combine(p)
      }
    }
    @normalized_progresses = durations
    @time_spend_this_month = @normalized_progresses.map { |p| p.work_duration }.sum
    render pdf: "#{@report_month}-report",
           :show_as_html => @debug_pdf,
           template: '/project/export/report.pdf.slim',
           disposition: "inline",
           layout: nil
  end

  private
  def export_params
    params.require(:export_options).permit(:month,:max_hours,:format)
  end
end
