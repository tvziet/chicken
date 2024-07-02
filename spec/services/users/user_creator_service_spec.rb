require 'rails_helper'

RSpec.describe Users::UserCreatorService, type: :service do
  let(:org_user_role) { create(:role, name: Role::ORG_USER) }
  let(:individual_user_role) { create(:role, name: Role::INDIVIDUAL_USER) }
  let(:user_params) do
    {
      email: 'test@example.com',
      password: 'p@ssw0rd',
      role_id: org_user_role.id,
      organization_attributes: {
        email: 'test@org.com',
        name: 'TEST ORG',
        short_name: 'TestOrg'
      }
    }
  end

  describe '#call' do
    context 'when the user represents an organization' do
      context 'when the organization does not exists' do
        it 'creates a new user and organization' do
          expect { Users::UserCreatorService.call(user_params) }.to change { User.count }.by(1).and change { Organization.count }.by(1)
        end

        it 'can not create an user with invalid email' do
          expect { Users::UserCreatorService.call(user_params.merge(email: '')) }.to change { User.count }.by(0).and change { Organization.count }.by(0)
        end

        it 'can not create an user with invalid password' do
          expect { Users::UserCreatorService.call(user_params.merge(password: '')) }.to change { User.count }.by(0).and change { Organization.count }.by(0)
        end
      end

      context 'when the organization exists' do
        let!(:organization) { create(:organization, email: 'test@org.com', name: 'TEST ORG', short_name: 'TestOrg') }

        it 'can not create a new user' do
          expect { Users::UserCreatorService.call(user_params) }.to change { User.count }.by(0).and change { Organization.count }.by(0)
        end
      end
    end

    context 'when the user is an individual' do
      let(:updated_user_params) { user_params.merge(role_id: individual_user_role.id).except(:organization_attributes) }

      it 'creates a new user' do
        expect { Users::UserCreatorService.call(updated_user_params) }.to change { User.count }.by(1)
      end

      it 'can not create an user with invalid email' do
        expect { Users::UserCreatorService.call(updated_user_params.merge(email: '')) }.to change { User.count }.by(0)
      end
    end
  end
end
