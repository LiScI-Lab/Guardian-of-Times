class User < ApplicationRecord
  enum role: {user: 0, admin: 100}

  acts_as_token_authenticatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  if Rails.env.production? or Settings.use_CAS
    devise :cas_authenticatable, :trackable
  else
    devise :database_authenticatable, :trackable
  end

  has_many :project_members, class_name: "Project::Member"
  has_many :invited_project_members, -> {kept.where(role: :invited)}, class_name: "Project::Member"
  has_many :involved_project_members, -> {kept.where.not(role: :invited)}, class_name: "Project::Member"
  has_many :own_project_members, -> {kept.where(role: :owner)}, class_name: "Project::Member"

  has_many :projects, through: :project_members, class_name: "Project"

  has_many :invited_projects, through: :invited_project_members, class_name: "Project", source: :project
  has_many :involved_projects, through: :involved_project_members, class_name: "Project", source: :project
  has_many :own_projects, through: :own_project_members, class_name: "Project", source: :project

  has_many :project_progresses, through: :project_members, class_name: "Project::Progress"

  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true

  def cas_extra_attributes=(attributes)
    self.email = attributes['mail']
    self.username = attributes['username']
    self.realname = attributes['displayName']
    self.department = attributes['department']
    if User.all.size == 0
      self.role = :admin
    end
  end
end
