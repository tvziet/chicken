# app/controllers/concerns/pagination_handler.rb
module PaginationHandler
  extend ActiveSupport::Concern

  def adjusted_page_param
    [params[:page].to_i, 1].max
  end

  def adjusted_per_page_param
    return Pagy::DEFAULT[:limit] if params[:per_page].to_i.negative? || params[:per_page].blank?

    params[:per_page].to_i
  end
end
