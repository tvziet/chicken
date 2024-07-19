require 'swagger_helper'

describe 'Roles API' do
  path '/api/roles' do
    get 'Retrieves all roles' do
      tags 'APIs'
      produces 'application/json'
      parameter name: :page, in: :query, type: :integer, description: 'current page number'
      parameter name: :per_page, in: :query, type: :integer, description: 'number of items per page'
      parameter name: 'X-API-VERSION', in: :header, type: :string, description: 'current version of API', required: true

      let(:page) { 1 }
      let(:per_page) { 5 }
      let('X-API-VERSION') { 'v1' }

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
  end
end
