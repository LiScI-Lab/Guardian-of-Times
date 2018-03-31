class CreateTags < ActiveRecord::Migration[5.1]
  def change
    create_table :tags do |t|
      t.string :name, unique: true, index: true
      t.string :description

      t.timestamps null: false
      t.datetime :discarded_at, index: true
    end
  end
end
