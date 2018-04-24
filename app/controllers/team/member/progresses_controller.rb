class Team::Member::ProgressesController < ApplicationController
  layout 'team'

  load_and_authorize_resource :team
  load_and_authorize_resource :member, class: Team::Member
  load_and_authorize_resource :progress, through: :member, class: Team::Progress

  #TODO: use materializecss datepicker instead of input field ??

  def index
    @progresses = @member.progresses
    @progress = Team::Progress.new(start: DateTime.now, team: @team, member: @member)
  end

  def create
    @progress.team = @team
    if @progress.save
      flash[:success] = "Progress successfully added"
      redirect_to team_member_progresses_path(@team, @member)
    else
      flash[:error] = "Progress not created"
      render 'new'
    end
  end

  def update
    if @progress.update progress_params
      flash[:success] = "Progress successfully updated"
      redirect_to team_member_progresses_path(@team, @member)
    else
      flash[:error] = "Progress not updated"
      render 'index'
    end
  end

  def start
    @progress = Team::Progress.new progress_params
    @progress.member = @member
    @progress.team = @team
    if @progress.save
      flash[:success] = "Progress successfully started"
      redirect_to team_member_progresses_path(@team, @member)
    else
      flash[:error] = "Progress not created"
      render 'index'
    end
  end

  def stop
    @progress.end = DateTime.now
    if @progress.save
      flash[:success] = "Progress successfully stopped"
    else
      flash[:error] = "Progress not stopped"
    end
    redirect_to team_member_progresses_path(@team, @member)
  end

  def destroy
    if @progress.discard
      flash[:success] = "Progress successfully discarded"
    else
      flash[:error] = "Progress not discarded"
    end
    redirect_to team_member_progresses_path(@team, @member)
  end

  def restore
    if @progress.undiscard
      flash[:success] = "Progress successfully undiscarded"
    else
      flash[:error] = "Progress not undiscarded"
    end
    redirect_to team_member_progresses_path(@team, @member)
  end

  def import
  end

  def upload
    i_params = import_params

    begin
      case i_params[:format].to_sym
      # when :csv
      #   raise ArgumentError, "not implemented"
      #   import_csv i_params[:file], i_params[:options]
      when :hamster
        import_hamster @member, i_params[:file], i_params[:options]
      else
        raise ArgumentError, "format not implemented"
      end
    rescue StandardError => error
      flash[:error] = error.message
    end
    redirect_to team_member_progresses_path @team, @member
  end

  def import_hamster member, file, options
    require "csv"
    CSV.read(file.path, { :col_sep => "\t" }).each_with_index do |row, i|
      next if i == 0 and options[:first_line_description]
      progress = import_progress_standard member, DateTime.parse(row[1]), DateTime.parse(row[2])
      progress.description = row[5] if row[5] and not ActiveModel::Type::Boolean.new.cast(options[:drop_description])
      progress.tag_list.add(row[0]) if row[0] and not ActiveModel::Type::Boolean.new.cast(options[:drop_work])
      progress.tag_list.add(row[4]) if row[4] and not ActiveModel::Type::Boolean.new.cast(options[:drop_category])
      progress.tag_list.add(row[6], parse: true) if row[6] and not ActiveModel::Type::Boolean.new.cast(options[:drop_tags])
      raise 'problems while saving progress' unless progress.save
    end
  end

  def import_progress_standard member, starttime, endtime
    raise 'start or end is missing' if starttime.nil? or endtime.nil?
    Team::Progress.new start: starttime, end: endtime, member: member, team: member.team
  end

  private
  def progress_params
    params.require(:progress).permit([:start, :end, :description, :tag_list])
  end

  def import_params
    params.require(:import).permit([:format, :file,
                                    options: [:first_line_description,
                                              :drop_tags, :drop_description, :drop_category, :drop_work]])
  end
end
