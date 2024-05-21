# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
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
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  before_validation :normalize_blank_name_to_nil

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable

  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validate :password_complexity

  def display_name
    name.presence || 'Name Not Provided'
  end

  def formatted_email
    email.downcase.gsub(/^(.{4})/, '****')
  end

  private

  def normalize_blank_name_to_nil
    self.name = nil if name.blank?
  end

  def password_complexity
    return if password.blank? || password =~ /(?=.*?[#?!@$%^&*\-;,.()=+|:])/

    errors.add :password, 'Complexity requirement not met. Please use at least one special character.'
  end
end
