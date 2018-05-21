class CreateTeamUnavailability < ActiveRecord::Migration[5.1]
  def change
    create_table :team_unavailabilities do |t|
      t.belongs_to :team, null: false, foreign_key: true
      t.belongs_to :team_member, null: false, foreign_key: true

      t.date :start, null: false
      t.date :end

      t.timestamps null: false
      t.datetime :discarded_at, index: true
    end
  end
end
