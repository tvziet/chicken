require 'swagger_helper'

describe 'Roles Admin' do
  let(:invalid_role_id) { 1_000 }
  let(:id) { create(:role, name: 'individual_user').id }
  let(:super_admin_id) { create(:role, name: 'super_admin').id }
  let(:org_admin_id) { create(:role, name: 'org_admin').id }
  let(:super_admin_user) { create(:user, role_id: super_admin_id) }
  let(:org_admin_user) { create(:user, role_id: org_admin_id) }
  let(:role_params) do
    {
      name: 'org_user'
    }
  end
  let(:Authorization) { include_auth_headers(super_admin_user)['Authorization'] }

  path '/admin/roles' do
    get 'Retrieves all roles' do
      tags 'Admin Interface - Role'
      produces 'application/json'
      parameter name: :page, in: :query, type: :integer, description: 'current page number'
      parameter name: :per_page, in: :query, type: :integer, description: 'number of items per page'

      let(:page) { 1 }
      let(:per_page) { 5 }

      response '200', 'Success response' do
        schema type: :object,
          properties: {
            data: {
              type: :object,
              properties: {
                items: {
                  type: :array,
                  items: {
                    type: :object,
                    properties: {
                      id: { type: :string },
                      type: { type: :string },
                      attributes: {
                        type: :object,
                        properties: {
                          name: { type: :string }
                        },
                        required: %w[name]
                      }
                    },
                    required: %w[id type attributes]
                  }
                },
                pagination: {
                  type: :object,
                  properties: {
                    limit_value: { type: :integer },
                    current_page: { type: :integer },
                    next_page: { type: :integer, 'x-nullable': true },
                    prev_page: { type: :integer, 'x-nullable': true },
                    total_pages: { type: :integer }
                  },
                  required: %w[limit_value current_page total_pages]
                }
              },
              required: %w[items pagination]
            }
          },
          required: %w[data]
        run_test!
      end
    end

    post 'Creates a role' do
      tags 'Admin Interface - Role'
      consumes 'application/json'
      security [{ bearer_auth: [] }]
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          role: { type: :object, properties: { name: { type: :string } } }
        },
        required: %w[role]
      }

      context 'when the current user is super admin' do
        context 'when the role is valid' do
          response '201', 'Role created' do
            let(:params) { { role: role_params.merge(name: 'individual_user') } }
            run_test!
          end
        end

        context 'when the role is not valid' do
          response '422', 'Failure role created' do
            let(:params) { { role: role_params.merge(name: 'teacher') } }
            run_test!
          end
        end
      end

      context 'when the current user is not super admin' do
        let(:Authorization) { include_auth_headers(org_admin_user)['Authorization'] }

        response '403', 'No permission' do
          let(:params) { { role: role_params.merge(name: 'individual_user') } }
          run_test!
        end
      end
    end
  end

  path '/admin/roles/{id}' do
    get 'Retrieves a role' do
      tags 'Admin Interface - Role'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string, require: true

      response '200', 'Role found' do
        schema type: :object,
          properties: {
            data: {
              type: :object,
              properties: {
                id: { type: :string },
                type: { type: :string },
                attributes: {
                  type: :object,
                  properties: {
                    name: { type: :string }
                  },
                  required: %w[name]
                }
              },
              required: %w[id type attributes]
            }
          },
          required: %w[data]

        let(:id) { create(:role, name: 'individual_user').id }
        run_test!
      end

      response '404', 'Role not found' do
        schema type: :object,
          properties: {
            errors: { type: :string }
          },
          required: %w[errors]
        let(:id) { invalid_role_id }
        run_test!
      end
    end

    put 'Updates a role' do
      tags 'Admin Interface - Role'

      produces 'application/json'
      consumes 'application/json'

      security [{ bearer_auth: [] }]

      parameter name: :id, in: :path, type: :string, require: true
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          role: { type: :object, properties: { name: { type: :string } } }
        },
        required: %w[role]
      }

      context 'when the current user is super admin' do
        context 'when the role exists' do
          response '200', 'Role updated' do
            let(:params) { { role: role_params } }
            run_test!
          end
        end

        context 'when the role does not exist' do
          let(:id) { invalid_role_id }

          response '404', 'Role not found' do
            schema type: :object,
              properties: {
                errors: { type: :string }
              },
              required: %w[errors]
            let(:params) { { role: role_params } }
            run_test!
          end
        end

        context 'when the role is not valid' do
          response '422', 'Failure role updated' do
            schema type: :object,
              properties: {
                errors: {
                  type: :object,
                  properties: {
                    name: { type: :array, items: { type: :string } }
                  }
                }
              },
              required: %w[errors]

            let(:params) { { role: role_params.merge(name: 'teacher') } }
            run_test!
          end
        end
      end

      context 'when the current user is not super admin' do
        let(:Authorization) { include_auth_headers(org_admin_user)['Authorization'] }

        response '403', 'No permission' do
          let(:params) { { role: role_params } }
          run_test!
        end
      end
    end

    delete 'Deletes a role' do
      tags 'Admin Interface - Role'
      produces 'application/json'
      security [{ bearer_auth: [] }]
      parameter name: :id, in: :path, type: :string, required: true

      context 'when the current user is super admin' do
        context 'when the role exists' do
          response '200', 'Role deleted' do
            schema type: :object,
              properties: {
                data: {
                  type: :string,
                  nullable: true,
                  example: nil
                }
              },
              required: %w[data]

            run_test!
          end
        end

        context 'when the role does not exist' do
          let(:id) { invalid_role_id }

          response '404', 'Role not found' do
            schema type: :object,
              properties: {
                errors: { type: :string }
              },
              required: %w[errors]

            run_test!
          end
        end
      end

      context 'when the user is not a super admin' do
        let(:Authorization) { include_auth_headers(org_admin_user)['Authorization'] }

        response '403', 'No permission' do
          schema type: :object,
            properties: {
              errors: { type: :string }
            },
            required: %w[errors]
          run_test!
        end
      end
    end
  end
end
