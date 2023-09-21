class MerchantBulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    require 'pry'; binding.pry
    @discount = BulkDiscount.find(params[:bulk_discount.id])
  end
end