class CreateProject < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.string :name, index: true, unique: true

      t.timestamps null: false
      t.datetime :discarded_at, index: true
    end
  end
end
