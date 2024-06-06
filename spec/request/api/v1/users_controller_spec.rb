require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  let(:org_user_role) { create(:role, name: Role::ORG_USER) }
  let(:headers) { { 'X-API-VERSION' => 'v1' } }

  describe 'POST /create' do
    context 'with valid parameters' do
      let(:valid_params) do
        {
          user: {
            email: 'test@example.com',
            password: 'p@ssw0rd',
            name: 'Test User',
            role_id: org_user_role.id,
            organization_attributes: {
              email: 'org@example.com',
              name: 'Test Org',
              short_name: 'TestOrg'
            }
          }
        }
      end

      it 'creates a new User' do
        expect {
          post api_users_path, params: valid_params, headers: headers
        }.to change(User, :count).by(1).and change { Organization.count }.by(1)
      end

      it 'returns a created status' do
        post api_users_path, params: valid_params, headers: headers
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          user: {
            email: 'test$example.com',
            password: '12312',
            name: 'Test User',
            role_id: nil,
            organization_attributes: {
              email: '',
              name: '',
              short_name: ''
            }
          }
        }
      end

      it 'does not create a new User' do
        expect {
          post api_users_path, params: invalid_params, headers: headers
        }.to_not change(User, :count)
      end

      it 'returns an unprocessable entity status' do
        post api_users_path, params: invalid_params, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
