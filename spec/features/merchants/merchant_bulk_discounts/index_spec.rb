require 'rails_helper'

RSpec.describe "Merchant Bulk Disconts Index Page", type: :feature do
  describe "As a Merchant" do
    describe "When I visit '/merchants/:id/bulk_discounts'" do
      before :each do
        @merchant1 = create(:merchant)
        @merchant2 = create(:merchant)
        @discount1 = BulkDiscount.create!(merchant_id: @merchant1.id, percentage: 5, threshold: 10)
        @discount2 = BulkDiscount.create!(merchant_id: @merchant1.id, percentage: 10, threshold: 15)
        @discount3 = BulkDiscount.create!(merchant_id: @merchant2.id, percentage: 20, threshold: 5)
        @discount4 = BulkDiscount.create!(merchant_id: @merchant2.id, percentage: 50, threshold: 10)
        visit merchant_bulk_discounts_path(@merchant1)
      end
      
      it "I see all of my bulk discounts, including their attributes, and a link to it's show page" do

        within("#discounts") do
          within("##{@discount1.id}") do
            expect(page).to have_content("ID: #{@discount1.id}")
            expect(page).to have_content("#{@discount1.percentage}% Off")
            expect(page).to have_content("All items purchased in quantities of #{@discount1.threshold} or more")
            expect(page).to have_link("Go to Discount: #{@discount1.id}'s Show Page", href: "/merchants/#{@merchant1.id}/bulk_discounts/#{@discount1.id}")
          end


          within("##{@discount2.id}") do
            expect(page).to have_content("ID: #{@discount2.id}")
            expect(page).to have_content("#{@discount2.percentage}% Off")
            expect(page).to have_content("All items purchased in quantities of #{@discount2.threshold} or more")
            expect(page).to have_link("Go to Discount: #{@discount2.id}'s Show Page", href: "/merchants/#{@merchant1.id}/bulk_discounts/#{@discount2.id}")
          end

          expect(page).not_to have_content("ID: #{@discount3.id}")
          expect(page).not_to have_content("ID: #{@discount4.id}")
        end
      end

      it "Next to each bulk discount I see a button to delete it, when I click it, I am brought back to this page and no longer see the discount" do

        within("#discounts") do
          within("##{@discount1.id}") do
            expect(page).to have_selector(:button, "Delete")
          end

          within("##{@discount2.id}") do
            expect(page).to have_selector(:button, "Delete")
          end
        end
        click_button("Delete", match: :first)
        
        expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))

        expect(page).to have_no_content(@discount1.id)
      end

      it "Then i see a link to create a new discount, I click it and am taken to a new page with the form" do

        expect(page).to have_link("Create a new Discount", href: "/merchants/#{@merchant1.id}/bulk_discounts/new")

        click_on "Create a new Discount"

        expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts/new")
      end
    end
  end
end