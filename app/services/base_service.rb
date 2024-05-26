# app/services/base_service.rb
class BaseService
  def self.call(*args, &block)
    new(*args, &block).call
  end

  private

  def success_response(data)
    {
      data: data
    }
  end

  def error_response(errors)
    {
      errors: errors.each_with_object({}) do |(key, value), result|
        result[key] = value.uniq.map { |error| "#{key.to_s.capitalize} #{error}" }
      end
    }
  end
end
