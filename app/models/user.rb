############
##
## Copyright 2018 M. Hoppe & N. Justus
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
## http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
############

class User < ApplicationRecord
  include Statistics

  enum role: {user: 0, admin: 100}

  acts_as_token_authenticatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :trackable,
         :omniauthable, omniauth_providers: Settings.omniauth.providers.enabled

  has_many :team_members, class_name: Team::Member.name
  has_many :invited_team_members, -> {kept.invited}, class_name: Team::Member.name
  has_many :requested_team_members, -> {kept.requested}, class_name: Team::Member.name
  has_many :involved_team_members, -> {kept.joined}, class_name: Team::Member.name
  has_many :own_team_members, -> {kept.owner}, class_name: Team::Member.name

  has_many :teams, through: :team_members, class_name: Team.name

  has_many :invited_teams, -> {order(:name)}, through: :invited_team_members, class_name: Team.name, source: :team
  has_many :requested_teams, -> {order(:name)}, through: :requested_team_members, class_name: Team.name, source: :team
  has_many :involved_teams, -> {order(:name)}, through: :involved_team_members, class_name: Team.name, source: :team
  has_many :own_teams, -> {order(:name)}, through: :own_team_members, class_name: Team.name, source: :team

  has_many :progresses, through: :team_members, class_name: Team::Progress.name

  has_many :identities, class_name: User::Identity.name

  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true

  mount_uploader :avatar, AvatarUploader

  before_save :update_generated_avatar

  before_discard :randomize_before_discard, unless: Settings.user.discard.disabled

  #tutorial from: http://stackoverflow.com/questions/21249749/rails-4-devise-omniauth-with-multiple-providers
  def self.from_omniauth(auth, current_user)
    if auth.provider.to_sym == :cas3
      identity = User::Identity.find_or_initialize_by provider: auth.provider, uid: auth.extra.user.to_s
    elsif auth.provider.to_sym == :google_oauth2
      identity = User::Identity.find_or_initialize_by provider: auth.provider, uid: auth.uid.to_s
    elsif auth.provider.to_sym == :developer
      identity = User::Identity.find_or_initialize_by provider: auth.provider, uid: auth.uid
    else
      identity = User::Identity.find_or_initialize_by provider: auth.provider, uid: auth.uid.to_s,
                                                      token: auth.credentials.token,
                                                      secret: auth.credentials.secret
    end

    if auth.info.image
      identity.avatar_url = auth.info.image
    end

    if auth.info.urls
      auth.info.urls.each do |url|
        identity.profile_page ||= url.last
      end
    end

    if identity.user.blank?
      if auth.provider == :cas3
        user = current_user || User.find_by(username: auth.extra.user)
      else
        user = current_user || User.find_by(email: auth.info.email)
      end
      if user.blank?
        user = User.new
        user.fetch_details(auth)
        user.save
      end
      identity.user = user
      identity.save
    end
    identity.user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["omniauth.auth"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def active_for_authentication?
    super && !discarded_at
  end

  def fetch_details(auth)
    if auth.provider == :cas3
      self.username = auth.extra.user
      self.email = "#{self.username}@change.me"
      self.first_name = self.username
      self.last_name = self.username
      self.department = "MNI"
    else
      if auth.info.first_name and auth.info.last_name
        self.first_name = auth.info.first_name
        self.last_name = auth.info.last_name
      else
        self.name = auth.info.name
      end
      self.email = auth.info.email || auth.info.nickname + '@change.me'
      self.username = auth.info.nickname || self.email
    end

    if User.all.size == 0
      self.role = :admin
    end
  end

  def name
    if first_name and last_name
      "#{first_name} #{last_name}#{" (#{I18n.t('global.discarded')})" if discarded?}"
    else
      "#{username}"
    end
  end

  def name=(value)
    self.first_name = value.split.first
    self.last_name = value.split.last
  end

  def logo_url
    if avatar_type.to_sym == :local and avatar?
      url = avatar_url
    elsif avatar_type.to_sym != :generator
      url = identities.find_by(provider: avatar_type)&.avatar_url
    end

    if avatar_type.to_sym == :generator or url.nil?
      url = generated_avatar_url
    end
    url
  end

  def generate_avatar
    Identicon.data_url_for(username, 256, [255, 255, 255])
  end

  def time_spend_series
    team_members.kept.map { |m|
      { name: m.team.name, data: m.time_spend_series }
    }
  end

  def current_month_actual_vs_expected_hours
    in_month_actual_vs_expected_hours(DateTime.now)
  end

  def in_month_actual_vs_expected_hours(date)
    timings_spend = team_members.map { |member| member.time_spend_data(date, by_team:true)}
    expected_timings = team_members.map { |member| member.expected_time_data(date, by_team:true)}
    [
        {name: I18n.t('dashboard.spend_hours'), data: timings_spend},
        {name: I18n.t('dashboard.target_hours'), data: expected_timings}
    ]
  end

  def current_month_spend_time_percentages
    in_month_spend_time_percentages(DateTime.now)
  end

  def in_month_spend_time_percentages(date)
    timings_spend = team_members.map { |member| member.spend_time_percentage_data(date, by_team:true)}
    [
        {name: I18n.t('dashboard.spend_hours_by_percentage'), data: timings_spend},
    ]
  end

  def running_progress?
    team_members.kept.select {|member| member.running_progress? }.any?
  end


  private
  def update_generated_avatar
    self.generated_avatar_url = self.generate_avatar
  end

  def randomize_before_discard
    if Settings.user.discard.randomize_personal_data
      self.avatar_type = :generator

      loop do
        self.last_name = Faker::Superhero.descriptor
        self.first_name = Faker::Superhero.suffix
        self.username = Faker::Internet.user_name
        self.email = Faker::Internet.email(self.first_name)

        break if self.valid?
      end
      self.department = Faker::Company.profession
      self.birth_date = Faker::Date.birthday(18, 65)
      self.last_sign_in_ip = Faker::Internet.public_ip_v4_address
      self.last_sign_in_at = Faker::Time.between(2.days.ago, Date.today, :all)
      self.current_sign_in_ip = Faker::Internet.public_ip_v4_address
      self.current_sign_in_at = Faker::Time.between(2.days.ago, Date.today, :all)
      self.remove_avatar!
      update_generated_avatar
    end

    if Settings.user.discard.destroy_identities
      self.identities.destroy_all
    end

    if Settings.user.discard.hand_over_teams
      self.team_members.each do |m|
        if m.owner?
          m.team.members.order(role: :desc).kept.each do |m1|
            if m1 != m and m1.joined?
              m1.owner!
              break
            end
          end
        end
        m.role = :participant
        m.leaved!
      end
    end

  end
end
