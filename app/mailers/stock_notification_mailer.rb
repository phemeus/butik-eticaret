# frozen_string_literal: true

class StockNotificationMailer < ApplicationMailer
  def back_in_stock(notification)
    @notification = notification
    @variant = notification.product_variant
    @product = @variant.product

    mail(
      to: notification.email,
      subject: "#{@product.name} tekrar stokta — #{site_name}"
    )
  end

  private

  def site_name
    SiteSetting.current.site_name
  end
end
