require 'rails_helper'

RSpec.describe "the Merchant Bulk Discount New page", type: :feature do
  describe "As a merchant" do
    describe "When I visit '/merchants/:id/bulk_discounts/new" do
      it "I see a form to add a new bulk discount, when I fill it in with valid data I am taken back to the bulk discount index page and see the new discount" do
        merchant1 = create(:merchant)
        merchant2 = create(:merchant)
        discount1 = BulkDiscount.create!(merchant_id: merchant1.id, percentage: 5, threshold: 10)
        discount2 = BulkDiscount.create!(merchant_id: merchant1.id, percentage: 10, threshold: 15)
        discount3 = BulkDiscount.create!(merchant_id: merchant2.id, percentage: 20, threshold: 5)
        discount4 = BulkDiscount.create!(merchant_id: merchant2.id, percentage: 50, threshold: 10)

        visit new_merchant_bulk_discount_path(merchant1)

        fill_in "Percentage", with: "15"
        fill_in "Threshold", with: "20"
        click_button "Submit"
        
        expect(current_path).to eq(merchant_bulk_discounts_path(merchant1))
        
        within("#discounts") do
            expect(page).to have_content("15% Off")
            expect(page).to have_content("All items purchased in quantities of 20 or more")
        end
      end
    end
  end
end