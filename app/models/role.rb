# == Schema Information
#
# Table name: roles
#
#  id         :uuid             not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_roles_on_name  (name) UNIQUE
#
class Role < ApplicationRecord
  # Constants to ensure we don't use invalid roles
  ORG_ADMIN = :org_admin
  SUPER_ADMIN = :super_admin
  ORG_USER = :org_user
  INDIVIDUAL_USER = :individual_user

  VALID_ROLES = %w[org_admin super_admin org_user individual_user].freeze

  TITLES = {
    org_admin: 'Organization Admin',
    super_admin: 'Super Admin',
    org_user: 'Organization User',
    individual_user: 'Individual User'
  }.freeze

  has_many :user_roles, dependent: :destroy
  has_many :users, through: :user_roles

  validates :name, presence: true, uniqueness: true, inclusion: { in: VALID_ROLES, message: '%{value} is not a valid role' }
end
