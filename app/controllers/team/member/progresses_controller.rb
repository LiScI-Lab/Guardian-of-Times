class Team::Member::ProgressesController < ApplicationController
  layout 'team'

  load_and_authorize_resource :team
  load_and_authorize_resource :member, class: Team::Member
  load_and_authorize_resource :progress, through: :member, class: Team::Progress

  #TODO: reuse form for new & edit; currently the partial is not found if i try to include it?.
  #TODO: use materializecss datepicker instead of input field ??

  def index
    @progresses = @member.progresses
    @progress = Team::Progress.new(start: DateTime.now, team: @team, member: @member)
  end

  def new
    @progress.team = @team
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
    params.require(:progress).permit([:start, :end, :description])
  end
end
