# frozen_string_literal: true

class Payment < ApplicationRecord
  belongs_to :order

  enum :status, {
    pending: 0,
    paid: 1,
    failed: 2,
    refunded: 3
  }, validate: true

  validates :amount_cents, numericality: { greater_than_or_equal_to: 0 }
end
