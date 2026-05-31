# frozen_string_literal: true

class Address < ApplicationRecord
  belongs_to :user
  has_many :orders, dependent: :restrict_with_error

  validates :title, :full_name, :phone, :city, :district, :address_line, presence: true
end
