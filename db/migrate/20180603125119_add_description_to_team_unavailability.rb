class AddDescriptionToTeamUnavailability < ActiveRecord::Migration[5.1]
  def change
    add_column :team_unavailabilities, :description, :text
  end
end
