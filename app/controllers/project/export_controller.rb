require 'project/work_duration'

class Project::ExportController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource :progress, through: :project

  #TODO:  use max_hours from project ; german month names !

  def index
    #setup values for month picker
    @month_with_index = Date::MONTHNAMES.each_with_index.collect{|m,i| [m,i]}
    @current_month = @month_with_index[DateTime.now.month]
  end

  def show
    @debug_pdf = params[:debug].present?
    @report_month = DateTime.now.last_month
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
    # render plain: durations.inspect
    render pdf: "#{@report_month}-report",
           :show_as_html => @debug_pdf,
           template: '/project/export/report.pdf.slim',
           disposition: "inline",
           layout: nil
    # respond_to do |format|
    #   format.html { render 'report' }
    #   format.pdf { render pdf: "#{month}-report", template: 'report' }
    # end

    # render plain: export_params
  end

  def create
    @debug_pdf = params[:debug].present?
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
    # render plain: durations.inspect
    render pdf: "#{@report_month}-report",
           :show_as_html => @debug_pdf,
           template: '/project/export/report.pdf.slim',
           disposition: "inline",
           layout: nil
    # respond_to do |format|
    #   format.html { render 'report' }
    #   format.pdf { render pdf: "#{month}-report", template: 'report' }
    # end

    # render plain: export_params
  end

  private
  def export_params
    params.require(:export_options).permit(:month,:max_hours)
  end
end
