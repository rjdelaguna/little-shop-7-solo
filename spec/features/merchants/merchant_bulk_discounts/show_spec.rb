require 'rails_helper'

RSpec.describe "Merchant Bulk Discounts Show Page", type: :feature do
  describe "As a Merchant" do
    describe "When I visit '/merchants/:id/bulk_discounts/:id'" do
      before :each do
        @merchant = create(:merchant)
        @discount = BulkDiscount.create!(merchant_id: @merchant.id, percentage: 5, threshold: 10)
        visit merchant_bulk_discount_path(@merchant, @discount)
      end

      it "Then I see the discount's quantity threshold and percentage" do

        expect(page).to have_content(@discount.percentage)
        expect(page).to have_content(@discount.threshold)
      end

      it "Then I see a link to edit the bulk discount, when I click it I am taken to the edit page" do

        expect(page).to have_link("Edit this Discount", href: "/merchants/#{@merchant.id}/bulk_discounts/#{@discount.id}/edit")
      end
    end
  end
end

