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
require 'rails_helper'

RSpec.describe Role, type: :model do
  let(:valid_roles) { Role::VALID_ROLES }
  let(:invalid_role) { 'invalid_role' }

  context 'associations' do
    it { should have_many(:user_roles).dependent(:destroy) }
    it { should have_many(:users).through(:user_roles) }
  end

  context 'validations' do
    it 'validates presence of name' do
      role = Role.new(name: nil)
      expect(role).to_not be_valid
      expect(role.errors[:name]).to include("can't be blank")
    end

    it 'validates uniqueness of name' do
      Role.create(name: valid_roles.first)
      role = Role.new(name: valid_roles.first)
      expect(role).not_to be_valid
      expect(role.errors[:name]).to include('has already been taken')
    end

    it 'validates inclusion of name in VALID_ROLES' do
      role = Role.new(name: invalid_role)
      expect(role).not_to be_valid
      expect(role.errors[:name]).to include("#{invalid_role} is not a valid role")
    end
  end
end
