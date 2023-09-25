class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  enum status: {
    "cancelled" => 0,
    "completed" => 1,
    "in progress" => 2
  }

  def self.not_shipped
    select("invoices.id, invoices.created_at").joins(:invoice_items).where("invoice_items.status != ?", 2).order("created_at asc").distinct
  end

  def date_conversion
    created_at.strftime("%A, %B %d, %Y")
  end

  def customer_name
    "#{customer.first_name} #{customer.last_name}"
  end

  def total_revenue
    invoice_items.sum('quantity * unit_price')/100.00
  end

  def discounted_revenue

    discounted = InvoiceItem
    .select('quantity, unit_price, highest_percentage, lowest_threshold')
    .from(
      invoice_items.joins(item: {merchant: :bulk_discounts})
      .where('invoice_items.quantity >= bulk_discounts.threshold')
      .select('invoice_items.quantity as quantity, invoice_items.unit_price as unit_price, max(bulk_discounts.percentage) as highest_percentage, min(bulk_discounts.threshold) as lowest_threshold')
      .group(:id)
    )
    .sum('((quantity * unit_price) * (1.0 - (highest_percentage / 100.0)) / 100.0)')

    full_price = InvoiceItem
    .select('quantity, unit_price, count, highest_percentage, lowest_threshold')
    .from(
      invoice_items.joins(item: {merchant: :bulk_discounts})
      .select('distinct invoice_items.*, count(bulk_discounts.id) as count, max(bulk_discounts.percentage) as highest_percentage, min(bulk_discounts.threshold) as lowest_threshold')
      .group(:id)
    )
    .where('quantity < lowest_threshold')
    .sum('(quantity * unit_price) / 100.0')

    discounted + full_price
  end
end