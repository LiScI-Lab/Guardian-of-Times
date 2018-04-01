class CreateJoinTableProjectMemberProjectProgress < ActiveRecord::Migration[5.1]
  def change
    create_join_table :project_members, :project_progresses do |t|
      t.index [:project_member_id, :project_progress_id], unique: true, name: 'index_project_members_progresses_member_id_progress_id'
      t.index [:project_progress_id, :project_member_id], unique: true, name: 'index_project_members_progresses_progress_id_member_id'
    end
  end
end
