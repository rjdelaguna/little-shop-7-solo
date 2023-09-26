class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  enum status: {
    "pending" => 0,
    "packaged" => 1,
    "shipped" => 2
  }

  def find_item
    Item.find(self.item_id)
  end

  def price
    unit_price / 100.0
  end

  def discount
    item.merchant.bulk_discounts
    .where("#{quantity} >= threshold")
    .order('percentage desc')
    .first
  end

  def self.find_invoice_items(invoice)
    all.where('invoice_id = ?', invoice.id)
  end
end