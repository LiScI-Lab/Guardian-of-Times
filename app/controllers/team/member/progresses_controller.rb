class Team::Member::ProgressesController < ApplicationController
  layout 'team'

  load_and_authorize_resource :team
  load_and_authorize_resource :member, class: Team::Member
  load_and_authorize_resource :progress, through: :member, class: Team::Progress

  #TODO: use materializecss datepicker instead of input field ??

  def index
    @month_with_index = Date::MONTHNAMES.each_with_index.collect{|m,i| [m,i]}
    @current_month = @month_with_index[DateTime.now.month]
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

  private
  def progress_params
    params.require(:progress).permit([:start, :end, :description, :tag_list])
  end

  def get_filtered_progresses(member)
    month_filter = params[:filter][:month] if params[:filter]
    tag_list ||= params[:filter][:tag_list] if params[:filter]

    progresses = if month_filter then
      month_date = Date.new(DateTime.now.year, month_filter.to_i)
      member.progresses.in_month(month_date)
    else
      member.progresses
    end

    if tag_list then
      progresses.tagged_with(tag_list, any: true)
    else
      progresses
    end

  end
end
