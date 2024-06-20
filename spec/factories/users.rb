# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
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
#  organization_id        :integer
#  role_id                :uuid
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_jti                   (jti) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_role_id               (role_id)
#

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password123' }
    password_confirmation { 'password123' }
    name { 'John Doe' }
    current_sign_in_at { Time.zone.now }
    current_sign_in_ip { '127.0.0.1' }
    last_sign_in_at { Time.zone.now }
    last_sign_in_ip { '127.0.0.1' }
    remember_created_at { Time.zone.now }
    reset_password_sent_at { Time.zone.now }
    reset_password_token { SecureRandom.hex(10) }
    sign_in_count { 1 }
    uid { SecureRandom.uuid }
    association :organization
    role_id { SecureRandom.uuid }
  end
end
