# frozen_string_literal: true

class CategoriesController < ApplicationController
  allow_unauthenticated_access only: %i[ index show ]

  def index
    @categories = Category.includes(:products).order(:name)
  end

  def show
    @category = Category.find_by!(slug: params[:slug])
    @products = @category.products.active.includes(:product_variants, images_attachments: :blob)
  end
end
