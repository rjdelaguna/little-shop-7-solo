require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  before(:each) do
    load_test_data
  end
  it { should belong_to :invoice }
  it { should belong_to :item }

  describe "instance methods" do
    describe "#find_item" do
      it "finds and returns item associated with and invoice_item" do
        
        expect(@invoice_item1.find_item).to eq(@item7)
      end
    end

    describe "#price" do
      it "returns unit_price calculated to dollars" do
        merchant = Merchant.create!(name: "Bubba's Boutique")
        spinner = merchant.items.create!(name: "Fidget Spinner", description: "Spins", unit_price: 1)
        cust = Customer.create!(first_name: "Dave", last_name: "Beckam")
        invoice = cust.invoices.create!(status: 1)
        invoice_item = InvoiceItem.create!(item_id: spinner.id, invoice_id: invoice.id, quantity: 20, status: 0, unit_price: 300)

        expect(invoice_item.price).to eq(3.0)
      end
    end

    describe "#discount" do
      it "returns the discount with the highest percentage, which is the discount applied" do
        merchant = Merchant.create!(name: "Bubba's Boutique")
        spinner = merchant.items.create!(name: "Fidget Spinner", description: "Spins", unit_price: 1)
        cust = Customer.create!(first_name: "Dave", last_name: "Beckam")
        invoice = cust.invoices.create!(status: 1)
        invoice_item = InvoiceItem.create!(item_id: spinner.id, invoice_id: invoice.id, quantity: 20, status: 0, unit_price: 300)
        discount1 = BulkDiscount.create!(merchant_id: merchant.id, percentage: 50, threshold: 20)
        discount2 = BulkDiscount.create!(merchant_id: merchant.id, percentage: 25, threshold: 20)

        expect(invoice_item.discount).to eq(discount1)
      end
    end
  end

  describe "class methods" do
    describe "#find_invoice_items" do
      it "returns all invoice_items associated with given invoice" do

        expect(InvoiceItem.find_invoice_items(@invoice11)).to eq([@invoice_item4])
      end
    end
  end
end