require 'rails_helper'

RSpec.describe 'Api::V1::Roles', type: :request do
  let!(:org_user_role) { create(:role, name: Role::ORG_USER) }
  let!(:individual_user_role) { create(:role, name: Role::INDIVIDUAL_USER) }

  let(:headers) { { 'X-API-VERSION' => 'v1' } }

  describe 'GET /roles' do
    it 'returns a successful response' do
      get api_roles_path, headers: headers
      expect(response).to have_http_status(:ok)
    end

    it 'returns all roles order by name' do
      get admin_roles_path
      expect(JSON.parse(response.body)['data']['items'].size).to eq(2)
      expect(JSON.parse(response.body)['data']['items'][0]['attributes']['name']).to eq('individual_user')
      expect(JSON.parse(response.body)['data']['items'][1]['attributes']['name']).to eq('org_user')
    end
  end
end

