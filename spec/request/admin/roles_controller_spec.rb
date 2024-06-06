require 'rails_helper'

RSpec.describe 'Admin::Roles', type: :request do
  let(:params) do
    {
      role: {
        name: Role::INDIVIDUAL_USER
      }
    }
  end

  describe 'GET /roles' do
    let!(:org_user_role) { create(:role, name: Role::ORG_USER) }
    let!(:individual_user_role) { create(:role, name: Role::INDIVIDUAL_USER) }

    it 'returns a successful response' do
      get admin_roles_path
      expect(response).to have_http_status(:ok)
    end

    it 'returns all roles order by name' do
      get admin_roles_path
      expect(JSON.parse(response.body)['data'].size).to eq(2)
      expect(JSON.parse(response.body)['data'][0]['attributes']['name']).to eq('individual_user')
      expect(JSON.parse(response.body)['data'][1]['attributes']['name']).to eq('org_user')
    end
  end

  describe 'POST /roles' do
    it 'creates a new role' do
      post admin_roles_path, params: params
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['data']['attributes']['name']).to eq(Role::INDIVIDUAL_USER.to_s)
    end

    it 'can not create a role with invalid name' do
      post admin_roles_path, params: params[:role].merge(name: 'teacher')
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe 'GET /roles/:id' do
    let(:org_user_role) { create(:role, name: Role::ORG_USER) }

    it 'returns a successful response' do
      get admin_role_path(org_user_role.id)
      expect(response).to have_http_status(:ok)
    end

    it 'returns a not found response' do
      get admin_role_path(1_000)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'PUT /roles/:id' do
    let(:org_user_role) { create(:role, name: Role::ORG_USER) }

    it 'returns a successful response' do
      put admin_role_path(org_user_role.id), params: params
      expect(response).to have_http_status(:ok)
    end

    it 'returns a unprocessable entity response' do
      put admin_role_path(org_user_role.id), params: params.merge(role: { name: 'teacher' })
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
