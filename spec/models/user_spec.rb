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
require 'rails_helper'

RSpec.describe User, type: :model do
  let(:role) { create(:role, name: Role::INDIVIDUAL_USER) }
  subject { build(:user, role_id: role.id) }

  context 'associations' do
    it { should belong_to(:organization).optional }
  end

  context 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should allow_value('test@example.com').for(:email) }
    it { should_not allow_value('test$example.com').for(:email) }
  end

  describe '#display_name' do
    context 'when name is present' do
      it 'returns the name' do
        subject.name = 'Test User'
        expect(subject.display_name).to eq('Test User')
      end
    end

    context 'when name is not present' do
      it 'returns the default display name' do
        subject.name = nil
        expect(subject.display_name).to eq('Name Not Provided')
      end
    end
  end

  describe '#formatted_email' do
    context 'when the length of the email before the @ character is greater than or equal to 4' do
      it 'returns the marked email' do
        subject.email = 'test@example.com'
        expect(subject.formatted_email).to eq('****@example.com')
      end
    end

    context 'when the length of the email before the @ character is less than 4' do
      it 'returns the marked email' do
        subject.email = 'abc@example.com'
        expect(subject.formatted_email).to eq('***@example.com')
      end
    end
  end

  describe '#role' do
    let(:role) { create(:role) }

    context 'when the role exists' do
      it 'returns the role' do
        subject.role_id = role.id
        expect(subject.role).to eq(role)
      end
    end

    context 'when the role does not exists' do
      it 'raises an ActiveRecord::RecordNotFound error' do
        subject.role_id = SecureRandom.hex
        expect { subject.role }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#organization' do
    let(:organization) { create(:organization) }

    context 'when the role is an organization user' do
      it 'returns the organization' do
        subject.role_id = create(:role, name: Role::ORG_USER).id
        subject.organization_id = organization.id
        expect(subject.organization).to eq(organization)
      end
    end

    context 'when the role is not an organization user' do
      it 'returns nil' do
        subject.role_id = role.id
        subject.organization_id = organization.id
        expect(subject.organization).to be_nil
      end
    end
  end
end
