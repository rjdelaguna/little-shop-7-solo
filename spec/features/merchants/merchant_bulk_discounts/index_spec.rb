require 'rails_helper'

RSpec.describe "Merchant Bulk Disconts Index Page", type: :feature do
  describe "As a Merchant" do
    describe "When I visit '/merchants/:id/bulk_discounts'" do
      it "I see all of my bulk discounts, including their attributes, and a link to it's show page" do
        merchant1 = create(:merchant)
        merchant2 = create(:merchant)
        discount1 = BulkDiscount.create!(merchant_id: merchant1.id, percentage: 5, threshold: 10)
        discount2 = BulkDiscount.create!(merchant_id: merchant1.id, percentage: 10, threshold: 15)
        discount3 = BulkDiscount.create!(merchant_id: merchant2.id, percentage: 20, threshold: 5)
        discount4 = BulkDiscount.create!(merchant_id: merchant2.id, percentage: 50, threshold: 10)

        visit merchant_bulk_discounts_path(merchant1)

        within("#discounts") do
          within("##{discount1.id}") do
            expect(page).to have_content("ID: #{discount1.id}")
            expect(page).to have_content("#{discount1.percentage}% Off")
            expect(page).to have_content("All items purchased in quantities of #{discount1.threshold} or more")
            expect(page).to have_link("Go to Discount: #{discount1.id}'s Show Page", href: "/merchants/#{merchant1.id}/bulk_discounts/#{discount1.id}")
          end

          within("##{discount2.id}") do
            expect(page).to have_content("ID: #{discount2.id}")
            expect(page).to have_content("#{discount2.percentage}% Off")
            expect(page).to have_content("All items purchased in quantities of #{discount2.threshold} or more")
            expect(page).to have_link("Go to Discount: #{discount2.id}'s Show Page", href: "/merchants/#{merchant1.id}/bulk_discounts/#{discount2.id}")
          end

          expect(page).not_to have_content(discount3.id)
          expect(page).not_to have_content(discount4.id)
        end
      end
    end
  end
end
            

