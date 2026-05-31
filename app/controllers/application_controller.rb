# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Authentication

  before_action :set_storefront_categories, unless: :admin_area?
  before_action :load_site_settings, unless: :admin_area?

  helper_method :current_cart, :site_settings

  private

  def admin_area?
    controller_path.start_with?("admin/")
  end

  def set_storefront_categories
    @categories = Rails.cache.fetch("storefront/categories/v1", expires_in: 10.minutes) do
      Category.order(:name).to_a
    end
  end

  def load_site_settings
    @site_settings = SiteSetting.current
  end

  def site_settings
    @site_settings
  end

  def current_cart
    return unless authenticated?

    Current.user.cart || Current.user.create_cart!
  end
end
