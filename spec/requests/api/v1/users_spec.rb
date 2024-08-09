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
  let(:update_profile_params) do
    {
      new_password: 'new_p@ssw0rd',
      current_password: 'p@ssw0rd',
      email: 'update@example.com',
      name: 'Updated User'
    }
  end
  let(:organization) { create(:organization, organization_attributes) }
  let(:individual_user) { create(:user, role_id: individual_user_role.id, password: 'p@ssw0rd') }
  let(:org_user) { create(:user, role_id: org_user_role.id, password: 'p@ssw0rd') }
  let(:Authorization) { include_auth_headers(individual_user)['Authorization'] }
  let('X-API-VERSION') { 'v1' }

  path '/api/users' do
    post 'Register' do
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

  path '/api/me' do
    get 'Returns the current user' do
      tags 'Users'
      produces 'application/json'

      security [{ bearer_auth: [] }]

      parameter name: 'X-API-VERSION', in: :header, type: :string, required: true, description: 'current version of API'

      context 'when the user is authenticated' do
        response '200', 'User found' do
          run_test!
        end
      end

      context 'when the user is not authenticated' do
        response '401', 'Unauthorized' do
          let(:Authorization) { nil }
          run_test!
        end
      end
    end
  end

  path '/api/current_user/profile' do
    put 'Updates the current user' do
      tags 'Users'

      produces 'application/json'
      consumes 'application/json'

      security [{ bearer_auth: [] }]

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          new_password: { type: :string },
          current_password: { type: :string },
          email: { type: :string },
          name: { type: :string }
        },
        required: [],
        dependencies: {
          new_password: %w[current_password]
        }
      }
      parameter name: 'X-API-VERSION', in: :header, type: :string, required: true, description: 'current version of API'

      context 'when the user is authenticated' do
        context 'when the new password is present' do
          context 'when the current password is correct' do
            context 'when the user is updated' do
              response '200', 'User updated' do
                let(:params) { update_profile_params }
                run_test!
              end
            end

            context 'when the user is not updated' do
              context 'when the email is blank' do
                response '422', 'Invalid request' do
                  let(:params) { update_profile_params.except(:email) }
                  run_test!
                end
              end
            end
          end

          context 'when the current password is incorrect' do
            response '422', 'Invalid request' do
              let(:params) { update_profile_params.merge(current_password: '') }
              run_test!
            end
          end
        end
      end

      context 'when the user is not authenticated' do
        response '401', 'Unauthorized' do
          let(:Authorization) { nil }
          let(:params) { update_profile_params }
          run_test!
        end
      end
    end
  end

  path '/api/current_user/switch_role' do
    put 'Switches role for the current user' do
      tags 'Users'

      produces 'application/json'
      consumes 'application/json'

      security [{ bearer_auth: [] }]

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          new_role_id: { type: :integer },
          organization_attributes: {
            type: :object,
            properties: {
              email: { type: :string },
              name: { type: :string },
              short_name: { type: :string }
            }
          }
        },
        required: %w[new_role_id]
      }
      parameter name: 'X-API-VERSION', in: :header, type: :string, required: true, description: 'current version of API'

      context 'when the user is authenticated' do
        context 'when the new role is not within the role array that is allowed to be updated' do
          response '404', 'Role not found' do
            let(:params) do
              {
                new_role_id: 1_000
              }
            end
            run_test!
          end
        end

        context 'when the new role is an organization user' do
          response '200', 'Switch role successfully' do
            let(:params) do
              {
                new_role_id: org_user_role.id,
                organization_attributes: organization_attributes
              }
            end
            run_test! do
              result = convert_to_json(response.body)
              expect(result[:data][:attributes][:role]).to eq(org_user_role.name)
              expect(result[:data][:attributes][:organization_name]).to eq(organization_attributes[:name])
              expect(Organization.where(organization_attributes).count).to eq(1)
            end
          end
        end

        context 'when the new role is an individual user' do
          response '200', 'Switch role successfully' do
            let(:Authorization) { include_auth_headers(org_user)['Authorization'] }
            let(:params) do
              {
                new_role_id: individual_user_role.id
              }
            end

            run_test! do
              result = convert_to_json(response.body)
              expect(result[:data][:attributes][:role]).to eq(individual_user_role.name)
              expect(result[:data][:attributes][:organization_name]).to be_nil
            end
          end
        end
      end

      context 'when the user is not authenticated' do
        response '401', 'Unauthorized' do
          let(:Authorization) { nil }
          let(:params) {}
          run_test!
        end
      end
    end
  end
end
