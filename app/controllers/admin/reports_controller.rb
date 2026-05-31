# frozen_string_literal: true

module Admin
  class ReportsController < BaseController
    def index
      @month_start = Time.current.beginning_of_month
      @month_orders = Order.completed_sales.where(created_at: @month_start..)
      @month_revenue_cents = @month_orders.sum(:total_cents)
      @month_order_count = @month_orders.count

      @top_products = OrderItem
        .joins(:order)
        .merge(Order.completed_sales.where(created_at: @month_start..))
        .group(:product_name)
        .sum(Arel.sql("quantity * unit_price_cents"))
        .sort_by { |_, cents| -cents }
        .first(5)
        .to_h

      @low_stock_variants = ProductVariant
        .includes(:product)
        .where("stock > 0 AND stock <= 3")
        .order(:stock)

      @pending_stock_notifications = StockNotification.pending.count
      @active_coupons_count = Coupon.active.count
    end
  end
end
