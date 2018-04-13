class CreateTagTarget < ActiveRecord::Migration[5.1]
  def change
    create_table :tag_targets do |t|
      t.belongs_to :team_member, null: true, foreign_key: true

      t.belongs_to :tag
      t.belongs_to :target, polymorphic: true

      t.timestamps null: false
      t.datetime :discarded_at, index: true

      t.index [:team_member_id, :tag_id, :target_type, :target_id], unique: true, name: 'index_tag_affecteds_on_everything'
    end
  end
end
