class CreateProjectProgressParticipant < ActiveRecord::Migration[5.1]
  def change
    create_table :project_progress_participants do |t|
      t.belongs_to :project_member, foreign_key: true
      t.belongs_to :project_progress, foreign_key: true
    end
  end
end
