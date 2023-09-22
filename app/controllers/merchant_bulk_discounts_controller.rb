class MerchantBulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    require 'pry'; binding.pry
    @discount = BulkDiscount.find(params[:bulk_discount.id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    BulkDiscount.create!(discount_params)
    redirect_to merchant_bulk_discounts_path(params[:merchant_id])
  end

  private

  def discount_params
    params.permit(:merchant_id, :percentage, :threshold)
  end
end