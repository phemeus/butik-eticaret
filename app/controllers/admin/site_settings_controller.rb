# frozen_string_literal: true

module Admin
  class SiteSettingsController < BaseController
    def edit
      @site_setting = SiteSetting.current
    end

    def update
      @site_setting = SiteSetting.current

      if @site_setting.update(site_setting_params)
        redirect_to edit_admin_site_settings_path, notice: "Site ayarları kaydedildi."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def site_setting_params
      params.require(:site_setting).permit(
        :site_name, :tagline, :contact_email,
        :hero_eyebrow, :hero_title, :hero_description, :hero_image,
        :newsletter_title, :newsletter_body,
        :free_shipping_threshold, :pdp_layout
      )
    end
  end
end
