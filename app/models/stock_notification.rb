# frozen_string_literal: true

class StockNotification < ApplicationRecord
  belongs_to :product_variant
  belongs_to :user, optional: true

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :email, uniqueness: {
    scope: :product_variant_id,
    conditions: -> { pending },
    message: "için zaten bildirim kaydı var"
  }

  scope :pending, -> { where(notified_at: nil) }

  def self.notify_for_variant!(variant)
    return unless variant.stock.positive?

    pending.where(product_variant: variant).find_each do |notification|
      StockNotificationMailer.back_in_stock(notification).deliver_later
      notification.update!(notified_at: Time.current)
    end
  end
end
