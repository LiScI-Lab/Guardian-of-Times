class CreateProjectProgress < ActiveRecord::Migration[5.1]
  def change
    create_table :project_progresses do |t|
      t.belongs_to :project, null: false, foreign_key: true

      t.datetime :start, null: false
      t.datetime :end
      t.string :description

      t.timestamps null: false
      t.datetime :discarded_at, index: true
    end
  end
end
