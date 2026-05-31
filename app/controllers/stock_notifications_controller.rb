# frozen_string_literal: true

class StockNotificationsController < ApplicationController
  allow_unauthenticated_access only: [ :create ]

  def create
    variant = ProductVariant.find(params[:product_variant_id])
    notification = StockNotification.new(
      product_variant: variant,
      email: notification_email,
      user: Current.user
    )

    if notification.save
      redirect_back fallback_location: product_path(variant.product), notice: "Stok gelince #{notification.email} adresine haber vereceğiz."
    else
      redirect_back fallback_location: product_path(variant.product), alert: notification.errors.full_messages.to_sentence
    end
  end

  private

  def notification_email
    if authenticated?
      Current.user.email_address
    else
      params.require(:email)
    end
  end
end
