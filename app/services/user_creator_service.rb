class UserCreatorService < BaseService
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def call
    user = User.new(params)
    return success_response(user) if user.save

    error_response(user.errors.to_hash)
  end
end
