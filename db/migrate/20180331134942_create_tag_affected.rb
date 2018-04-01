class CreateTagAffected < ActiveRecord::Migration[5.1]
  def change
    create_table :tag_affecteds do |t|
      t.belongs_to :project_member, null: true, foreign_key: true

      t.belongs_to :tag
      t.belongs_to :affected, polymorphic: true

      t.index [:project_member_id, :tag_id, :affected_type, :affected_id], unique: true, name: 'index_tag_affecteds_on_everything'
    end
  end
end
