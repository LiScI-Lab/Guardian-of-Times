class Team::Member::ProgressesController < SecurityController
  include ::ProgressFilter
  layout 'team'

  load_and_authorize_resource :team
  load_and_authorize_resource :member, class: Team::Member
  load_and_authorize_resource :progress, through: :member, class: Team::Progress

  #TODO: use materializecss datepicker instead of input field ??

  def index
    @progresses = get_filtered_progresses(@member)
    @progress = Team::Progress.new(start: DateTime.now, team: @team, member: @member)
    @tag_list = Team::Progress.tags_on(:tag)
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
    # if @progress.save
    #   flash[:success] = "Progress successfully started"
    #   redirect_to team_member_progresses_path(@team, @member)
    # else
      flash[:error] = "Progress not created"
      render 'index'
    #end
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
      when :csv_nico
        import_csv_nico @member, i_params[:file], i_params[:options]
      when :csv_kimai
        import_csv_kimai @member, i_params[:file], i_params[:options]
      when :hamster
        import_hamster @member, i_params[:file], i_params[:options]
      else
        raise ArgumentError, "format not implemented"
      end
      flash[:success] = "Import successful."
    rescue StandardError => error
      flash[:error] = error.message
    end
    redirect_to team_member_progresses_path @member.team, @member
  end

  def import_csv_nico member, file, options
    require "csv"
    File.foreach(file.path).with_index do |line, i|
      next if i == 0 and options[:first_line_description]
      row = CSV.parse(line).first

      progress = import_progress_standard member, "#{row[0]} #{row[1]}", "#{row[0]} #{row[2]}"

      progress.description = row[4] if row[4] and not ActiveModel::Type::Boolean.new.cast(options[:drop_description])
      raise 'problems while saving progress' unless progress.save
    end
  end

  def import_csv_kimai member, file, options
    require "csv"
    File.foreach(file.path).with_index do |line, i|
      next if i == 0 and options[:first_line_description]
      row = CSV.parse(line).first
      row[0] = if row[0].split('.').length == 2 then "#{row[0]}#{Time.zone.now.year}" else row[0] end
      progress = import_progress_standard member, "#{row[0]} #{row[1]}", "#{row[0]} #{row[2]}"

      progress.description = row[14] if row[14] and not ActiveModel::Type::Boolean.new.cast(options[:drop_description])
      progress.tag_list.add(row[9]) if row[9] and not ActiveModel::Type::Boolean.new.cast(options[:drop_status])
      progress.tag_list.add(row[11]) if row[11] and not ActiveModel::Type::Boolean.new.cast(options[:drop_customer])
      progress.tag_list.add(row[12]) if row[12] and not ActiveModel::Type::Boolean.new.cast(options[:drop_project])
      progress.tag_list.add(row[13]) if row[13] and not ActiveModel::Type::Boolean.new.cast(options[:drop_activity])
      progress.tag_list.add(row[16]) if row[16] and not ActiveModel::Type::Boolean.new.cast(options[:drop_location])
      progress.tag_list.add(row[18]) if row[18] and not ActiveModel::Type::Boolean.new.cast(options[:drop_user])
      raise 'problems while saving progress' unless progress.save
    end
  end

  def import_hamster member, file, options
    require "csv"

    CSV.read(file.path, { col_sep: "\t" }).each_with_index do |row, i|
      next if i == 0 and options[:first_line_description]
      progress = import_progress_standard member, row[1], row[2]
      progress.description = row[5] if row[5] and not ActiveModel::Type::Boolean.new.cast(options[:drop_description])
      progress.tag_list.add(row[0]) if row[0] and not ActiveModel::Type::Boolean.new.cast(options[:drop_activity])
      progress.tag_list.add(row[4]) if row[4] and not ActiveModel::Type::Boolean.new.cast(options[:drop_category])
      progress.tag_list.add(row[6], parse: true) if row[6] and not ActiveModel::Type::Boolean.new.cast(options[:drop_tags])
      raise 'problems while saving progress' unless progress.save
    end
  end

  def import_progress_standard member, starttime, endtime
    starttime = Time.zone.parse starttime
    endtime = Time.zone.parse endtime
    if endtime < starttime
      endtime = endtime + 1.days
    end
    raise 'start or end is missing' if starttime.nil? or endtime.nil?
    Team::Progress.new start: starttime, end: endtime, member: member, team: member.team
  end

  private
  def progress_params
    params.require(:progress).permit([:start, :end, :description, :tag_list])
  end

  def import_params
    params.require(:import).permit([:format, :file,
                                    options: [:first_line_description, :drop_description,
                                              :drop_tags,
                                              :drop_status, :drop_customer, :drop_user, :drop_project, :drop_activity, :drop_location,
                                              :drop_category]])
  end
end
