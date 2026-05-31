# frozen_string_literal: true

module Admin
  class OrdersController < BaseController
    before_action :set_order, only: %i[ show update ]

    def index
      @orders = Order.recent.includes(:user, :payment)
    end

    def show
    end

    def update
      if @order.update(order_params)
        redirect_to admin_order_path(@order), notice: "Sipariş durumu güncellendi."
      else
        redirect_to admin_order_path(@order), alert: @order.errors.full_messages.to_sentence
      end
    end

    private

    def set_order
      @order = Order.includes(:order_items, :address, :payment, :shipment, :user).find(params[:id])
    end

    def order_params
      params.require(:order).permit(:status)
    end
  end
end
