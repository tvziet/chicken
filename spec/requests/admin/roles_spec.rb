require 'swagger_helper'

describe 'Roles Admin' do
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
      parameter name: :role, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        },
        required: %w[name]
      }
      response '201', 'Role created' do
        let(:role) do
          {
            name: 'individual_user'
          }
        end
        let(:params) { { role: role } }
        run_test!
      end
      response '422', 'Failure role created' do
        let(:role) do
          {
            name: 'teacher'
          }
        end
        let(:params) { { role: role } }
        run_test!
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
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
