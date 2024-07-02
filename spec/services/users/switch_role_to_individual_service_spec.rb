require 'rails_helper'

RSpec.describe Users::SwitchRoleToIndividualService do
  describe '#call' do
    let(:organization) { create(:organization) }
    let(:org_user) { create(:user, role_id: original_role_id, organization: organization) }
    let(:original_role_id) { create(:role, name: Role::ORG_USER).id }
    let(:new_role_id) { create(:role, name: Role::INDIVIDUAL_USER).id }

    context 'when the new role is different from the current role' do
      it 'successfully switches the user role' do
        service = described_class.new(org_user, new_role_id)
        service.call

        expect(org_user.role_id).to eq(new_role_id)
        expect(UserRole.exists?(user_id: org_user.id, role_id: original_role_id)).to be_falsey
        expect(UserRole.exists?(user_id: org_user.id, role_id: new_role_id)).to be_truthy
        expect { organization.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when the new role is the same as the current role' do
      it 'returns an error and does not change the role' do
        service = described_class.new(org_user, original_role_id)
        service.call

        expect(org_user.errors.messages[:new_role_id]).to include(I18n.t('api.users.switch_role.no_change'))
        expect(org_user.role_id).to eq(original_role_id)
      end
    end
  end
end
