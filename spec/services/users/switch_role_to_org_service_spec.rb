require 'rails_helper'

RSpec.describe Users::SwitchRoleToOrgService do
  describe '#call' do
    let(:individual_user) { create(:user, role_id: original_role_id, organization: organization) }
    let(:original_role_id) { create(:role, name: Role::INDIVIDUAL_USER).id }
    let(:new_role_id) { create(:role, name: Role::ORG_USER).id }
    let(:organization_attributes) do
      {
        email: 'test@organization.com',
        name: 'Test Organization',
        short_name: 'TestOrg'
      }
    end
    let(:update_organization_attributes) do
      {
        email: 'test.update@organization.com',
        name: 'Test Organization Update',
        short_name: 'TestOrgUpdate'
      }
    end
    let(:organization) { create(:organization, organization_attributes) }

    context 'when the information of organization is registered by another user' do
      it 'returns an error and does not change the role' do
        service = described_class.new(individual_user, organization_attributes, new_role_id)
        service.call

        expect(individual_user.errors.messages[:organization]).to include(I18n.t('api.users.switch_role.organization_registered'))
      end
    end

    context 'when the information of organization is not registered by another user' do
      context 'when the current user is representing organization information' do
        before do
          individual_user.update!(organization: organization)
        end

        it 'returns the new information for the organization' do
          service = described_class.new(individual_user, update_organization_attributes, new_role_id)
          result = service.call

          expect(result[:data].organization.email).to eq(update_organization_attributes[:email])
          expect(result[:data].organization.name).to eq(update_organization_attributes[:name])
          expect(result[:data].organization.short_name).to eq(update_organization_attributes[:short_name])
        end
      end

      context 'when the current user is not representing organization information' do
        it 'returns new organization for the current user' do
          service = described_class.new(individual_user, update_organization_attributes, new_role_id)
          service.call

          expect(Organization.where(email: update_organization_attributes[:email],
                                    name: update_organization_attributes[:name],
                                    short_name: update_organization_attributes[:short_name]).count).to eq(1)
        end
      end
    end
  end
end
