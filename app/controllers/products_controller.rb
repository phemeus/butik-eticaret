# frozen_string_literal: true

class ProductsController < ApplicationController
  allow_unauthenticated_access only: %i[ index show ]

  def index
    @products = base_products
    @products = @products.where(category_id: params[:category_id]) if params[:category_id].present?
    @products = @products.where("products.name ILIKE ?", "%#{Product.sanitize_sql_like(params[:q])}%") if params[:q].present?
    @categories = Category.with_attached_image.order(:name)
  end

  def show
    @product = Product.active.includes(:product_variants, :category, images_attachments: :blob).find_by!(slug: params[:slug])
  end

  private

  def base_products
    scope = Product.active.includes(:category, :product_variants, images_attachments: :blob)

    case params[:sort]
    when "featured"
      scope.featured_now
    when "new"
      arrivals = scope.new_arrival_now
      arrivals.exists? ? arrivals : scope.order(created_at: :desc)
    else
      scope.order(created_at: :desc)
    end
  end
end
