# frozen_string_literal: true

module Admin
  class CouponsController < BaseController
    before_action :set_coupon, only: %i[ edit update destroy ]

    def index
      @coupons = Coupon.order(created_at: :desc)
    end

    def new
      @coupon = Coupon.new(active: true, discount_type: :percent, discount_value: 10)
    end

    def create
      @coupon = Coupon.new(coupon_params)

      if @coupon.save
        redirect_to admin_coupons_path, notice: "Kupon oluşturuldu."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @coupon.update(coupon_params)
        redirect_to admin_coupons_path, notice: "Kupon güncellendi."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @coupon.destroy
      redirect_to admin_coupons_path, notice: "Kupon silindi."
    end

    private

    def set_coupon
      @coupon = Coupon.find(params[:id])
    end

    def coupon_params
      params.require(:coupon).permit(
        :code, :discount_type, :discount_value, :fixed_amount,
        :minimum_order, :max_uses, :expires_at, :active
      )
    end
  end
end
