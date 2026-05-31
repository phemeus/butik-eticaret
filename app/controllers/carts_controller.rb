# frozen_string_literal: true

class CartsController < ApplicationController
  def show
    @cart = current_cart
    @cart_items = @cart.cart_items.includes(product_variant: { product: { images_attachments: :blob } })
  end

  def apply_coupon
    @cart = current_cart
    coupon = Coupon.find_applicable(params[:code])

    if coupon.nil?
      redirect_to cart_path, alert: "Kupon bulunamadı."
    elsif !coupon.applicable_to?(@cart.subtotal_cents)
      redirect_to cart_path, alert: "Kupon geçerli değil veya minimum sepet tutarını karşılamıyorsunuz."
    else
      @cart.update!(coupon: coupon)
      redirect_to cart_path, notice: "Kupon uygulandı: #{coupon.label}"
    end
  end

  def remove_coupon
    current_cart.remove_coupon!
    redirect_to cart_path, notice: "Kupon kaldırıldı."
  end
end
