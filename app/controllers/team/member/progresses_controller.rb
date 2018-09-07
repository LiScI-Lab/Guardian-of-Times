############
##
## Copyright 2018 M. Hoppe & N. Justus
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
## http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
############

class Team::Member::ProgressesController < SecurityController
  include ::ProgressFilter
  layout 'team'

  load_and_authorize_resource :team
  load_resource :member, class: Team::Member
  load_and_authorize_resource :progress, through: :member, class: Team::Progress

  def index
    @progresses = get_filtered_progresses(@member)
    @progress = Team::Progress.new(start: DateTime.now, team: @team, member: @member)
  end

  def create
    @progress.team = @team
    if @progress.save
      if params[:button] == 'start'
        flash[:success] = "Progress successfully started"
      else
        flash[:success] = "Progress successfully added"
      end
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
      render 'edit'
    end
  end

  def duplicate
    #duplicate selected progress & "restart" the duplicate
    duplicate_progress = @progress.dup
    duplicate_progress.start = DateTime.now
    duplicate_progress.end = nil
    #dup does not copy associations, so do it manually
    duplicate_progress.tag_list =  @progress.tags
    duplicate_progress.save!
    redirect_to team_member_progresses_path(@team, @member)
  end

  def restart
    @progress.end = nil
    if @progress.save
      flash[:success] = "Progress successfully restarted"
    else
      flash[:error] = "Progress not restarted"
    end
    redirect_to team_member_progresses_path(@team, @member)
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
      when :csv
        import_csv @member, i_params[:file], i_params[:options]
      when :csv_nico
        import_csv_nico @member, i_params[:file], i_params[:options]
      when :csv_kimai
        import_csv_kimai @member, i_params[:file], i_params[:options]
      when :hamster
        import_hamster @member, i_params[:file], i_params[:options]
      when :csv_stundenzettel
        import_stundenzettel_csv @member, i_params[:file], i_params[:options]
      else
        raise ArgumentError, I18n.t('errors.messages.format_not_implemented')
      end
      flash[:success] = "Import successful."
    rescue StandardError => error
      #flash[:error] = error.message
      raise error
    end
    redirect_to team_member_progresses_path @member.team, @member
  end

  def import_csv member, file, options
    require "csv"
    File.foreach(file.path).with_index do |line, i|
      next if i == 0 and options[:first_line_description]
      row = CSV.parse(line, col_sep: ';').first
      progress = import_progress_standard member, row[0], row[1]
      progress.description = row[2] if row[2] and not ActiveModel::Type::Boolean.new.cast(options[:drop_description])
      progress.tag_list.add(row[3], parse: true) if row[3] and not ActiveModel::Type::Boolean.new.cast(options[:drop_tags])
      raise 'problems while saving progress' unless progress.save
    end
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

  def import_stundenzettel_csv member, file, options
    require 'csv'

    CSV.parse(File.readlines(file.path, encoding: 'UTF-8').drop(8).join) do |row|
      date,starttime,endtime,timespan_str = row
      next if date.blank? || date.downcase == "datum" || starttime.blank? || endtime.blank?

      start = Time.zone.parse(date+" "+starttime).to_datetime
      timespan = Time.zone.parse(timespan_str).to_datetime unless timespan_str.blank?
      progress = Team::Progress.new start: start, member: member, team: member.team
      progress.end = timespan ? start.advance(hours: timespan.hour,minutes: timespan.minute) : Time.zone.parse(date+" "+endtime)
      raise 'problems while saving progress' unless progress.save
    end
  end

  def import_progress_standard member, starttime, endtime
    starttime = Time.zone.parse starttime
    endtime = Time.zone.parse endtime
    if endtime < starttime
      endtime = endtime + 1.days
    end
    raise I18n.t('errors.messages.start_or_end_is_missing') if starttime.nil? or endtime.nil?
    raise I18n.t('errors.messages.start_and_end_are_identical', date: l(starttime, format: :long)) if starttime == endtime
    raise I18n.t('errors.messages.duration_less_than', date: l(starttime, format: :long), count: Settings.team.progress.minimum_duration_for_import) if (endtime - starttime) < Settings.team.progress.minimum_duration_for_import

    Team::Progress.new start: starttime, end: endtime, member: member, team: member.team
  end

  private
  def progress_params
    p = params.require(:progress).permit([:start_date, :start_time, :end_date, :end_time, :description, :tag_list, :own_tag_list])
    if p[:own_tag_list].present?
      p[:own_tag_list] = {owner: @current_member, tag_list: p[:own_tag_list]}
    end
    p
  end

  def import_params
    params.require(:import).permit([:format, :file,
                                    options: [:first_line_description, :drop_description,
                                              :drop_tags,
                                              :drop_status, :drop_customer, :drop_user, :drop_project, :drop_activity, :drop_location,
                                              :drop_category]])
  end
end
