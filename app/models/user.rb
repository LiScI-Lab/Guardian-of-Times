class User < ApplicationRecord
  acts_as_token_authenticatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  if Rails.env.production? or Settings.use_CAS
    devise :cas_authenticatable, :trackable
  else
    devise :database_authenticatable, :trackable
  end

  has_many :project_members, class_name: "Project::Member"
  has_many :projects, through: :project_members, class_name: "Project"
  has_many :project_progresses, through: :project_members, class_name: "Project::Progress"
end
