# spec/support/api_helpers.rb
module ApiHelpers
  def include_auth_headers(user)
    token = user.generate_access_token
    { 'Authorization' => "Bearer #{token}" }
  end
end
