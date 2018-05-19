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
  has_many :involved_team_members, -> {kept.joined.where.not(role: :owner)}, class_name: Team::Member.name
  has_many :own_team_members, -> {kept.owner}, class_name: Team::Member.name

  has_many :teams, through: :team_members, class_name: Team.name

  has_many :invited_teams, through: :invited_team_members, class_name: Team.name, source: :team
  has_many :involved_teams, through: :involved_team_members, class_name: Team.name, source: :team
  has_many :own_teams, through: :own_team_members, class_name: Team.name, source: :team

  has_many :progresses, through: :team_members, class_name: Team::Progress.name

  has_many :identities, class_name: User::Identity.name

  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true

  mount_uploader :avatar, AvatarUploader

  before_save :update_generated_avatar

  #tutorial from: http://stackoverflow.com/questions/21249749/rails-4-devise-omniauth-with-multiple-providers
  def self.from_omniauth(auth, current_user)
    if auth.provider.to_sym == :cas3 or auth.provider.to_sym == :google_oauth2
      identity = User::Identity.find_or_initialize_by provider: auth.provider, uid: auth.uid.to_s
    else
      identity = User::Identity.find_or_initialize_by provider: auth.provider, uid: auth.uid.to_s,
                                                      token: auth.credentials.token,
                                                      secret: auth.credentials.secret
    end

    if identity.new_record?
      if auth.info.image
        identity.avatar_url = auth.info.image
      end

      if auth.info.urls
        auth.info.urls.each do |url|
          identity.profile_page ||= url.last
        end
      end

    end

    if identity.user.blank?
      if auth.provider == :cas3
        user = current_user || User.find_by(username: auth.extra.username)
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

  def fetch_details(auth)
    if auth.provider == :cas3
      self.username = auth.extra.username
      self.email = auth.extra.mail
      self.first_name = auth.extra.firstnames
      self.last_name = auth.extra.surnames
      self.department = auth.extra.department
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
      "#{first_name} #{last_name}"
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
      url = identities.find_by(provider: avatar_type).avatar_url
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

  private
  def update_generated_avatar
    self.generated_avatar_url = self.generate_avatar
  end
end
