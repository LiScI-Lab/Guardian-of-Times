class Team::MembersProgresses < ApplicationRecord
  belongs_to :progress, inverse_of: :team_members_progresses, foreign_key: :team_progress_id, class_name: Team::Progress.name
  belongs_to :member, inverse_of: :team_members_progresses, foreign_key: :team_member_id, class_name: Team::Member.name
end