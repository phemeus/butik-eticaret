# frozen_string_literal: true

module Admin
  class ProductsController < BaseController
    before_action :set_product, only: %i[ show edit update destroy ]

    def index
      @products = Product.includes(:category).order(created_at: :desc)
    end

    def show
    end

    def new
      @product = Product.new(active: true)
      @categories = Category.order(:name)
    end

    def create
      @product = Product.new(product_params)
      @categories = Category.order(:name)

      if @product.save
        redirect_to admin_product_path(@product.id), notice: "Ürün oluşturuldu."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @categories = Category.order(:name)
    end

    def update
      @categories = Category.order(:name)

      if @product.update(product_params)
        redirect_to admin_product_path(@product.id), notice: "Ürün güncellendi."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @product.destroy
      redirect_to admin_products_path, notice: "Ürün silindi."
    end

    private

    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(
        :name, :slug, :description, :price, :active, :category_id,
        :featured, :new_arrival, :featured_until, :new_arrival_until,
        :meta_title, :meta_description,
        images: []
      )
    end
  end
end
