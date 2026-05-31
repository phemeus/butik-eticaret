# frozen_string_literal: true

class PasswordsController < ApplicationController
  allow_unauthenticated_access
  before_action :set_user_by_token, only: %i[ edit update ]

  def new
  end

  def create
    if user = User.find_by(email_address: params[:email_address])
      # MVP: token tabanlı sıfırlama ileride eklenebilir
    end

    redirect_to new_session_path, notice: "Şifre sıfırlama bağlantısı gönderildi (MVP: henüz aktif değil)."
  end

  def edit
  end

  def update
    if @user.update(params.permit(:password, :password_confirmation))
      redirect_to new_session_path, notice: "Şifreniz güncellendi."
    else
      redirect_to edit_password_path(params[:token]), alert: "Şifre güncellenemedi."
    end
  end

  private

  def set_user_by_token
    @user = User.first
    redirect_to new_password_path, alert: "Geçersiz bağlantı." unless @user
  end
end
