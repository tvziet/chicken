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
class RoleSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name
end
