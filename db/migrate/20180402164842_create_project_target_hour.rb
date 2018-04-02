class CreateProjectTargetHour < ActiveRecord::Migration[5.1]
  def change
    create_table :project_target_hours do |t|
      t.date :since, null: false
      t.integer :hours, null: false, default: 0
      t.belongs_to :project_member, foreign_key: true
    end
  end
end
