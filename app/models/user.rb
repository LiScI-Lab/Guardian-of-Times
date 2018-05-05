class User < ApplicationRecord
  include Statistics

  enum role: {user: 0, admin: 100}

  acts_as_token_authenticatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  if Rails.env.production? or Settings.use_CAS
    devise :cas_authenticatable, :trackable
  else
    devise :database_authenticatable, :trackable
  end

  has_many :team_members, class_name: Team::Member.name
  has_many :invited_team_members, -> {kept.invited}, class_name: Team::Member.name
  has_many :involved_team_members, -> {kept.joined.where.not(role: :owner)}, class_name: Team::Member.name
  has_many :own_team_members, -> {kept.owner}, class_name: Team::Member.name

  has_many :teams, through: :team_members, class_name: Team.name

  has_many :invited_teams, through: :invited_team_members, class_name: Team.name, source: :team
  has_many :involved_teams, through: :involved_team_members, class_name: Team.name, source: :team
  has_many :own_teams, through: :own_team_members, class_name: Team.name, source: :team

  has_many :progresses, through: :team_members, class_name: Team::Progress.name

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
