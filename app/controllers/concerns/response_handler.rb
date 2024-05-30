# frozen_string_literal: true

module ResponseHandler
  extend ActiveSupport::Concern

  def json_with_error(message: :fail, errors: nil)
    {
      errors: format_active_record_errors(errors) || message
    }
  end

  private

  def format_active_record_errors(errors)
    return {} if errors.nil? || !errors.is_a?(Hash)

    errors
  end
end
