require 'swagger_helper'

RSpec.describe 'Sessions API', type: :request do
  let(:individual_user_role) { create(:role, name: Role::INDIVIDUAL_USER) }
  let(:individual_user) { create(:user, role_id: individual_user_role.id, password: 'p@ssw0rd') }
  let(:user_credentials) { { email: individual_user.email, password: 'p@ssw0rd' } }
  let('X-API-VERSION') { 'v1' }

  path '/api/login' do
    post 'Login' do
      tags 'Users'
      consumes 'application/json'
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          user: { type: :object,
                  properties: {
                    email: { type: :string },
                    password: { type: :string }
                  } }
        },
        required: %w[user]
      }
      parameter name: 'X-API-VERSION', in: :header, type: :string, required: true, description: 'current version of API'

      context "when the user's credentials are correct" do
        response '200', 'Login successfully' do
          let(:params) do
            { user: user_credentials }
          end
          run_test!
        end
      end

      context "when the user's credentials are incorrect" do
        response '401', 'Unauthorized' do
          let(:params) do
            { user: user_credentials.merge(password: '123123') }
          end
          run_test!
        end
      end
    end
  end
end
