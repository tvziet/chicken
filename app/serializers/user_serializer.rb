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
class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :email, :name, :is_verified
  attribute :role do |object|
    object.role.name
  end
end
