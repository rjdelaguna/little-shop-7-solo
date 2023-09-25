require "rails_helper"

RSpec.describe "the admin_invoices id show page", type: :feature do
  describe "As an admin" do
    describe "When I visit '/admin/invoices/:invoice_id" do
      before :each do
        @merchant1 = Merchant.create!(name: "Merchant")
        
        @item1 = @merchant1.items.create!(name: "Item 1", description: "First Item", unit_price: 10)
        @item2 = @merchant1.items.create!(name: "Item 2", description: "Second Item", unit_price: 20)
        @item3 = @merchant1.items.create!(name: "Item 3", description: "Third Item", unit_price: 30)
        
        @customer1 = Customer.create!(first_name: "John" , last_name: "Smith")
       
        @invoice1 = @customer1.invoices.create!(status: 1)
        
        @invoice_item1 = InvoiceItem.create!(item_id: @item1.id, invoice_id: @invoice1.id, quantity: 1, unit_price: 10, status: 2)
        @invoice_item2 = InvoiceItem.create!(item_id: @item2.id, invoice_id: @invoice1.id, quantity: 2, unit_price: 20, status: 2)
        @invoice_item3 = InvoiceItem.create!(item_id: @item3.id, invoice_id: @invoice1.id, quantity: 3, unit_price: 30, status: 2)
        BulkDiscount.create!(merchant_id: @merchant1.id, percentage: 50, threshold: 3)
        BulkDiscount.create!(merchant_id: @merchant1.id, percentage: 25, threshold: 2)
        visit "/admin/invoices/#{@invoice1.id}"
      end

      it "Then I see information related to that invoice: id, status, created_at, Customer first and last name" do
        
        expect(page).to have_content(@invoice1.id)
        expect(page).to have_content(@invoice1.status)
        expect(page).to have_content(@invoice1.date_conversion)
        expect(page).to have_content(@customer1.first_name)
        expect(page).to have_content(@customer1.last_name)
      end

      it "Then I see all of the items on the invoice, including: name, quantity, price, status" do
        within("#item-#{@item1.id}") do
          expect(page).to have_content(@item1.name)
          expect(page).to have_content(@invoice_item1.quantity)
          expect(page).to have_content(@item1.unit_price)
          expect(page).to have_content(@invoice_item1.status)
        end

        within("#item-#{@item2.id}") do
          expect(page).to have_content(@item2.name)
          expect(page).to have_content(@invoice_item2.quantity)
          expect(page).to have_content(@item2.unit_price)
          expect(page).to have_content(@invoice_item2.status)
        end

        within("#item-#{@item3.id}") do
          expect(page).to have_content(@item3.name)
          expect(page).to have_content(@invoice_item3.quantity)
          expect(page).to have_content(@item3.unit_price)
          expect(page).to have_content(@invoice_item3.status)
        end
      end

      it "Then I see the total revenue that will be generated from this invoice" do
        expect(page).to have_content(@invoice1.total_revenue)
      end

      it "I see that status is a select field with the current status selected, I can select a new status and submit, then I return to this page with the updated status" do
        customer = Customer.create!(first_name: "John" , last_name: "Smith")
        invoice = customer.invoices.create!(status: 1)

        visit "/admin/invoices/#{invoice.id}"

        select "in progress", :from => "Invoice Status:"

        click_button "Update Invoice Status"

        expect(current_path).to eq("/admin/invoices/#{invoice.id}")
        
        expect(page).to have_content("in progress")
      end

      it "I see the total discounted revenue from this invoice" do
        
        expect(page).to have_content(@invoice1.discounted_revenue)
      end
    end
  end
end
