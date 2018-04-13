class CreateTeamProgress < ActiveRecord::Migration[5.1]
  def change
    create_table :team_progresses do |t|
      t.belongs_to :team, null: false, foreign_key: true

      t.datetime :start, null: false
      t.datetime :end
      t.text :description

      t.timestamps null: false
      t.datetime :discarded_at, index: true
    end
  end
end
