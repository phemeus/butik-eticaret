# frozen_string_literal: true

module Admin
  class BaseController < ApplicationController
    layout "admin"

    before_action :require_admin!

    private

    def require_admin!
      redirect_to root_path, alert: "Bu alana erişim yetkiniz yok." unless Current.user&.admin?
    end
  end
end
