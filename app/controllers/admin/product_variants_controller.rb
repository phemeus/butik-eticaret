# frozen_string_literal: true

module Admin
  class ProductVariantsController < BaseController
    before_action :set_product, only: %i[ new create ]
    before_action :set_variant, only: %i[ edit update destroy ]

    def new
      @variant = @product.product_variants.build
    end

    def create
      @variant = @product.product_variants.build(variant_params)

      if @variant.save
        redirect_to admin_product_path(@product.id), notice: "Varyant eklendi."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @product = @variant.product
    end

    def update
      @product = @variant.product

      if @variant.update(variant_params)
        redirect_to admin_product_path(@product.id), notice: "Varyant güncellendi."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      product = @variant.product
      @variant.destroy
      redirect_to admin_product_path(product.id), notice: "Varyant silindi."
    end

    private

    def set_product
      @product = Product.find(params[:product_id])
    end

    def set_variant
      @variant = ProductVariant.find(params[:id])
    end

    def variant_params
      params.require(:product_variant).permit(:color, :size, :stock, :sku, :price)
    end
  end
end
