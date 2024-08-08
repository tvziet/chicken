# spec/support/api_helpers.rb
module ApiHelpers
  def include_auth_headers(user)
    token = user.generate_access_token
    { 'Authorization' => "Bearer #{token}" }
  end

  def convert_to_json(response_body)
    JSON.parse(response_body).with_indifferent_access
  end
end
