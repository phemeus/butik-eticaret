# frozen_string_literal: true

class AddressesController < ApplicationController
  before_action :set_address, only: %i[ edit update destroy ]

  def index
    @addresses = Current.user.addresses.order(:title)
  end

  def new
    @address = Current.user.addresses.build
  end

  def create
    @address = Current.user.addresses.build(address_params)

    if @address.save
      redirect_to addresses_path, notice: "Adres eklendi."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @address.update(address_params)
      redirect_to addresses_path, notice: "Adres güncellendi."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @address.destroy
    redirect_to addresses_path, notice: "Adres silindi."
  end

  private

  def set_address
    @address = Current.user.addresses.find(params[:id])
  end

  def address_params
    params.require(:address).permit(:title, :full_name, :phone, :city, :district, :address_line, :postal_code)
  end
end
