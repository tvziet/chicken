require 'swagger_helper'

RSpec.describe 'Users API', type: :request do
  let(:individual_user_role) { create(:role, name: Role::INDIVIDUAL_USER) }
  let(:org_user_role) { create(:role, name: Role::ORG_USER) }
  let(:user_params) do
    {
      email: 'test@example.com',
      password: 'p@ssw0rd',
      name: 'Test User',
      role_id: individual_user_role.id
    }
  end
  let(:organization_attributes) do
    {
      email: 'test.ltd@company.com',
      name: 'Test Ltd',
      short_name: 'TL'
    }
  end
  let(:organization) { create(:organization, organization_attributes) }
  let('X-API-VERSION') { 'v1' }

  path '/api/users' do
    post 'Creates a user' do
      tags 'Users'
      consumes 'application/json'
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string },
          name: { type: :string },
          role_id: { type: :integer },
          organization_attributes: {
            type: :object,
            properties: {
              email: { type: :string },
              name: { type: :string },
              short_name: { type: :string }
            }
          }
        },
        required: %w[email password name role_id]
      }
      parameter name: 'X-API-VERSION', in: :header, type: :string, required: true, description: 'current version of API'

      context 'with valid parameters' do
        context 'when the user is an individual user' do
          response '201', 'User created' do
            let(:params) { { user: user_params } }
            run_test! do
              result = convert_to_json(response.body)
              expect(result[:data][:attributes][:email]).to eq(user_params[:email])
              expect(result[:data][:attributes][:name]).to eq(user_params[:name])
              expect(result[:data][:attributes][:role]).to eq(individual_user_role.name)
              expect(result[:data][:attributes][:organization_name]).to be_nil
            end
          end
        end

        context 'when the user represents an organization' do
          context 'when the organization is not registered' do
            response '201', 'User created' do
              let(:params) { { user: user_params.merge(role_id: org_user_role.id, organization_attributes: organization_attributes) } }
              run_test! do
                result = convert_to_json(response.body)
                expect(result[:data][:attributes][:email]).to eq(user_params[:email])
                expect(result[:data][:attributes][:name]).to eq(user_params[:name])
                expect(result[:data][:attributes][:role]).to eq(org_user_role.name)
                expect(result[:data][:attributes][:organization_name]).to eq(organization_attributes[:name])
                expect(Organization.where(organization_attributes).count).to eq(1)
              end
            end
          end

          context 'when the organization is already registered' do
            response '422', 'Invalid request' do
              let(:organization) { create(:organization) }
              let(:organization_attributes) do
                {
                  email: organization.email,
                  name: organization.name,
                  short_name: organization.short_name
                }
              end
              let(:params) { { user: user_params.merge(role_id: org_user_role.id, organization_attributes: organization_attributes) } }
              run_test!
            end
          end
        end
      end

      context 'with invalid parameters' do
        context 'when without password' do
          response '422', 'Invalid request' do
            let(:params) { { user: user_params.except(:password) } }
            run_test!
          end
        end

        context 'when non-exist role' do
          response '404', 'Role is not found' do
            let(:params) { { user: user_params.merge(role_id: 1_000) } }
            run_test!
          end
        end
      end
    end
  end
end
