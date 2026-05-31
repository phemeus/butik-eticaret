# frozen_string_literal: true

class CartItemsController < ApplicationController
  before_action :set_cart
  before_action :set_cart_item, only: %i[ update destroy ]

  def create
    variant = ProductVariant.find(params[:product_variant_id])
    item = @cart.cart_items.find_or_initialize_by(product_variant: variant)

    if item.persisted?
      item.quantity += params.fetch(:quantity, 1).to_i
    else
      item.quantity = params.fetch(:quantity, 1).to_i
    end

    if item.save
      respond_to do |format|
        format.html { redirect_back fallback_location: cart_path, notice: "Sepete eklendi." }
        format.turbo_stream
      end
    else
      redirect_back fallback_location: cart_path, alert: item.errors.full_messages.to_sentence
    end
  end

  def update
    if @cart_item.update(cart_item_params)
      respond_to do |format|
        format.html { redirect_to cart_path, notice: "Sepet güncellendi." }
        format.turbo_stream
      end
    else
      redirect_to cart_path, alert: @cart_item.errors.full_messages.to_sentence
    end
  end

  def destroy
    @cart_item.destroy

    respond_to do |format|
      format.html { redirect_to cart_path, notice: "Ürün sepetten çıkarıldı." }
      format.turbo_stream
    end
  end

  private

  def set_cart
    @cart = current_cart
  end

  def set_cart_item
    @cart_item = @cart.cart_items.find(params[:id])
  end

  def cart_item_params
    params.require(:cart_item).permit(:quantity)
  end
end
