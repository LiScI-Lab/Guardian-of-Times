class CreateProjectProgress < ActiveRecord::Migration[5.1]
  def change
    create_table :project_progresses do |t|
      t.datetime :start
      t.datetime :end
      t.string :description

      t.timestamps null: false
      t.datetime :discarded_at, index: true
    end
  end
end
