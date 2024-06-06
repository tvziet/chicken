# frozen_string_literal: true

module ResponseHandler
  extend ActiveSupport::Concern

  def json_with_error(message: :fail, errors: nil)
    formatted_errors = format_active_record_errors(errors)
    {
      errors: formatted_errors.presence || message
    }
  end

  private

  def format_active_record_errors(errors)
    (errors.nil? || !errors.is_a?(Hash)) ? {} : errors
  end
end
