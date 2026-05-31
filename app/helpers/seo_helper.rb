# frozen_string_literal: true

module SeoHelper
  def page_meta_description
    content_for(:meta_description).presence || site_settings.tagline
  end
end
