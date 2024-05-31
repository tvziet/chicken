require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

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
end
