class Project::Progress < ApplicationRecord
  belongs_to :project, class_name: "Project"

  has_and_belongs_to_many :members, class_name: "Project::Member", foreign_key: :project_progress_id, association_foreign_key: :project_member_id

  has_many :tag_affecteds, as: :affected, class_name: "TagAffected"
  has_many :tags, through: :tag_affecteds, class_name: "Tag"

  scope :in_month, -> (date){where(start: date.beginning_of_month..date.end_of_month)}
  scope :this_month, -> {in_month(DateTime.now)}
  scope :ongoing, -> {where end: nil}

  validates :start, presence: true

  after_initialize :set_start

  def finished?
    not self[:end].nil?
  end

  def end
    self[:end] || Time.zone.now
  end

  def time_spend
    ActiveSupport::Duration.build((self.end - start).seconds)
  end

  private
  def set_start
    self.start = start || DateTime.now
  end
end
