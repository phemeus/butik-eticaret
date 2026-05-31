# frozen_string_literal: true

module Admin
  class DashboardController < BaseController
    def index
      @product_count = Product.count
      @order_count = Order.count
      @pending_orders = Order.pending.count
    end
  end
end
