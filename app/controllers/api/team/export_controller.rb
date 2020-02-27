class Api::Team::ExportController
  load_and_authorize_resource :team
  authorize_resource :export, class: false

  def create
    #TODO: Test!
    @debug_pdf = params[:debug].present? || export_params[:format] == :html.to_s
    @report_month = DateTime.parse export_params[:month]
    @team_name = @current_member.team.name
    durations = generate_export_durations(@current_member, @report_month)

    #generate a list of all days of a month (1..31) and pair it with the working ours [day,woring_duration]
    #if there is no working our for a specific day, make it [day,nil]
    days_in_month = (1..Time.days_in_month(@report_month.month, @report_month.year)).map { |d| Date.new(@report_month.year,@report_month.month,d) }
    worked_days = durations.map { |d| [d.date.to_date, d] }.to_h
    @normalized_progresses = days_in_month.map { |d| [d, worked_days[d]] }.to_h

    @time_spend_this_month = @normalized_progresses
                                 .select { |k,p| not p.nil? }
                                 .map { |k,p| p.work_duration }.sum

    render pdf: "#{@report_month.strftime("%Y-%m")}-#{@team_name}-stundenzettel",
           :show_as_html => @debug_pdf,
           template: '/team/export/report.pdf.slim',
           disposition: "inline",
           layout: nil
  end

  private
  def export_params
    params.require(:export_options).permit(:month,:max_hours,:format, :normalize)
  end

  def generate_export_durations(member, month)
    should_normalize = export_params[:normalize] && export_params[:normalize] == "1"
    progresses_current_month = member.progresses.kept.in_month(month).all
    #normalize durations by scaling using the factor: target_seconds/total_time_spend_seconds
    target_seconds = member.matching_target_hours(month) * 3600 if should_normalize
    total_time_spend = member.in_month_time_spend(month).to_d if should_normalize
    normalize_factor = (target_seconds.to_d / total_time_spend).round(4) if should_normalize
    progresses_current_month
        .sort_by {|p| p.start}
        .map {|p|
          #to duration & normalize
          duration = Team::WorkDuration.new(p.start, p.start, p.end)
          (normalize_factor) ? duration.scale_duration_by(normalize_factor) : duration
        }
        .group_by {|p| p.date.to_date}
        .map {|date, values|
          values.reduce {|acc, p|
            acc.combine(p)
          }
        }
  end
end
