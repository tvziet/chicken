# frozen_string_literal: true

module ResponseHandler
  extend ActiveSupport::Concern

  def json_with_error(message: :fail, errors: nil)
    formatted_errors = format_active_record_errors(errors)
    {
      errors: formatted_errors.presence || message
    }
  end

  def json_with_success(message: nil, data: nil, options: {})
    {
      message: options[:message] || message || 'Success',
      data: data ? serialize_data(data, options) : nil
    }
  end

  def json_with_pagination(message: nil, data: nil, custom_serializer: nil, options: {})
    {
      message: options[:message] || message || 'Success',
      data: data ? pagination_json(data, custom_serializer: custom_serializer, options: options) : nil
    }
  end

  private

  def format_active_record_errors(errors)
    (errors.nil? || !errors.is_a?(Hash)) ? {} : errors
  end

  def serialize_data(data, options)
    serializer = options[:serializer] || "#{data.class}Serializer".constantize
    meta_data = options.except(:serializer)
    serializable_data = serializer ? serializer.new(data).serializable_hash[:data] : data
    (meta_data.present? && serializable_data.present?) ? serializable_data.merge!(meta_data) : serializable_data
  end

  def pagination_json(data, custom_serializer: nil, options: {})
    pagination =
      if data.respond_to?(:cursor)
        {
          cursor: data.cursor
        }
      else
        {
          limit_value: (data.respond_to?(:limit_value) && data.limit_value) ? data.limit_value : 0,
          current_page: data.respond_to?(:current_page) ? data.current_page : 1,
          next_page: data.respond_to?(:next_page) ? data.next_page : nil,
          prev_page: data.respond_to?(:prev_page) ? data.prev_page : nil,
          total_pages: data.respond_to?(:total_pages) ? data.total_pages : 1
        }
      end

    options = custom_serializer ? { each_serializer: custom_serializer }.merge(options) : options

    serializer = "#{data.klass.name}Serializer".constantize

    {
      pagination: pagination,
      items: serializer.new(data, options).serializable_hash[:data]
    }
  end
end
