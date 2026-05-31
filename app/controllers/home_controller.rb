# frozen_string_literal: true

class HomeController < ApplicationController
  allow_unauthenticated_access only: [ :index ]

  def index
    product_scope = Product.active.includes(:category, :product_variants, images_attachments: :blob)

    @categories = Category.with_attached_image.order(:name)
    @trust_blocks = ContentBlock.for_section(:trust)
    @new_arrivals = product_scope.new_arrival_now.limit(8)
    @new_arrivals = product_scope.order(created_at: :desc).limit(8) if @new_arrivals.empty?
    @featured_products = product_scope.featured_now.limit(8)
    @popular_products = product_scope.order(updated_at: :desc).limit(8)
  end
end
