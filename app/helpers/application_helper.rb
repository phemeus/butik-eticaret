# frozen_string_literal: true

module ApplicationHelper
  def format_price(cents)
    number_to_currency(cents / 100.0, unit: "₺", format: "%n %u", delimiter: ".", separator: ",")
  end

  def order_status_badge(status)
    css = {
      "pending" => "secondary",
      "confirmed" => "primary",
      "preparing" => "info",
      "shipped" => "warning",
      "delivered" => "success",
      "cancelled" => "danger"
    }[status.to_s] || "secondary"

    content_tag(:span, I18n.t("activerecord.attributes.order.status.#{status}"), class: "badge bg-#{css}")
  end

  def payment_status_badge(status)
    css = {
      "pending" => "secondary",
      "paid" => "success",
      "failed" => "danger",
      "refunded" => "warning"
    }[status.to_s] || "secondary"

    content_tag(:span, I18n.t("activerecord.attributes.payment.status.#{status}"), class: "badge bg-#{css}")
  end
end
