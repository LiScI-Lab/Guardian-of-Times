class WelcomeController < ApplicationController
  authorize_resource class: false

  def index
    @users_count = User.kept.count
    @teams_count = Team.kept.count
    @total_time = Team::Progress.kept.pluck(:start,:end).map { |(start,endt)| endt - start }.sum
  end
end
