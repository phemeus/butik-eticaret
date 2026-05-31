# frozen_string_literal: true

class OrdersController < ApplicationController
  def index
    @orders = Current.user.orders.recent.includes(:payment, :order_items)
  end

  def show
    @order = Current.user.orders.includes(:address, :order_items, :payment, :shipment).find(params[:id])
  end

  def new
    @cart = current_cart
    redirect_to cart_path, alert: "Sepetiniz boş." if @cart.empty?

    @order = Order.new
    @addresses = Current.user.addresses.order(:title)
  end

  def create
    @cart = current_cart
    address = Current.user.addresses.find(params[:address_id])

    @order = Order.create_from_cart!(
      user: Current.user,
      cart: @cart,
      address: address,
      notes: params[:notes]
    )

    redirect_to @order, notice: "Siparişiniz oluşturuldu."
  rescue ActiveRecord::RecordInvalid => e
    redirect_to new_order_path, alert: e.record.errors.full_messages.to_sentence.presence || "Sipariş oluşturulamadı."
  end
end
