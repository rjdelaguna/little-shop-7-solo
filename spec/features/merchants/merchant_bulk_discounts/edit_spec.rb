require 'rails_helper'

RSpec.describe "Merchant Bulk Discounts Edit Page", type: :feature do
  describe "As a Merchant" do
    describe "When I visit '/merchants/:id/bulk_discounts/:id/edit'" do
      before :each do
        @merchant = create(:merchant)
        @discount = BulkDiscount.create!(merchant_id: @merchant.id, percentage: 5, threshold: 10)
        visit edit_merchant_bulk_discount_path(@merchant, @discount)
      end

      it "I see a form to edit the discount with the current attributes pre-populated, when I change any/all of these a click submit, I am redirected to the Bulk Discount's Show page an see the updated attributes" do
        expect(page).to have_field("Percentage", with: "#{@discount.percentage}")
        expect(page).to have_field("Threshold", with: "#{@discount.threshold}")

        fill_in "Percentage", with: "20"
        fill_in "Threshold", with: "30"
        
        click_button "Submit"

        expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts/#{@discount.id}")
        expect(page).not_to have_content("5% Off")
        expect(page).not_to have_content("All items purchased in quantities of 10 or more.")
        expect(page).to have_content("20% Off")
        expect(page).to have_content("All items purchased in quantities of 30 or more.")
      end
    end
  end
end