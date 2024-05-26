# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
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
#  organization_id        :integer
#  role_id                :integer
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_role_id               (role_id)
#
class User < ApplicationRecord
  before_validation :normalize_blank_name_to_nil

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable

  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP, message: 'is not a valid email address' }
  validate :password_complexity

  belongs_to :organization, optional: true
  accepts_nested_attributes_for :organization

  def display_name
    name.presence || 'Name Not Provided'
  end

  def formatted_email
    email.downcase.gsub(/^(.{4})/, '****')
  end

  def role
    Role.find_by(id: role_id)
  end

  private

  def normalize_blank_name_to_nil
    self.name = nil if name.blank?
  end

  def password_complexity
    return if password.blank? || password =~ /(?=.*?[#?!@$%^&*\-;,.()=+|:])/

    errors.add :password, 'complexity requirement not met. Please use at least one special character.'
  end
end