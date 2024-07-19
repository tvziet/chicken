# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  confirmation_token     :string
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  is_verified            :boolean          default(FALSE)
#  jti                    :string           not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  name                   :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  uid                    :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  organization_id        :uuid
#  role_id                :uuid
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_jti                   (jti) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_role_id               (role_id)
#
class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  LENGTH_EMAIL_PART = 4
  DEFAULT_DISPLAY_NAME = 'Name Not Provided'.freeze
  EMAIL_SYMBOL = '@'.freeze

  before_validation :normalize_blank_name_to_nil
  before_validation :ensure_matching_roles
  before_create :generate_confirmation_token

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable,
    :jwt_authenticatable, jwt_revocation_strategy: self

  validates :email, presence: true
  validates :email, uniqueness: { case_sensitive: false },
    format: { with: URI::MailTo::EMAIL_REGEXP, message: 'is not a valid email address' },
    if: -> { email.present? }
  validate :password_complexity

  belongs_to :organization, optional: true
  accepts_nested_attributes_for :organization

  def display_name
    name.presence || DEFAULT_DISPLAY_NAME
  end

  def formatted_email
    email_part, domain_part = email.downcase.split(EMAIL_SYMBOL)
    masked_email = (email_part.length >= LENGTH_EMAIL_PART) ? email_part.gsub(/^(.{#{LENGTH_EMAIL_PART}})/, '****') : email_part.gsub(/./, '*')
    masked_email + EMAIL_SYMBOL + domain_part
  end

  def role
    Role.find(role_id)
  end

  delegate :name, to: :role, prefix: true

  def organization
    Organization.find(organization_id) if role_name == Role::ORG_USER.to_s && organization_id.present?
  end

  private

  def normalize_blank_name_to_nil
    self.name = nil if name.blank?
  end

  def password_complexity
    return if password.blank? || password =~ /(?=.*?[#?!@$%^&*\-;,.()=+|:])/

    errors.add :password, 'complexity requirement not met. Please use at least one special character.'
  end

  def generate_confirmation_token
    self.confirmation_token = SecureRandom.urlsafe_base64
  end

  def ensure_matching_roles
    errors.add(:role_id, I18n.t('api.users.common.not_matching_role')) if Role::REGISTERABLE_ROLES.exclude?(role_name)
  end
end
