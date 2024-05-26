# Description: Base service class to be inherited by all services.
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
    return { errors: errors.transform_values { |v| v.is_a?(Array) ? v.uniq : v } } if errors.is_a?(Hash)

    {
      errors: errors.each_with_object({}) do |(key, value), result|
        result[key] = value.uniq.map { |error| "#{key.to_s.capitalize} #{error}" }
      end
    }
  end
end
