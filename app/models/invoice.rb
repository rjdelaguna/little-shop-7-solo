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
    discounted = invoice_items
    .joins(item: {merchant: :bulk_discounts})
    .where('quantity >= bulk_discounts.threshold')
    .sum('(quantity * invoice_items.unit_price) * (bulk_discounts.percentage / 100.0)')
    
    full_price = invoice_items
    .joins(item: {merchant: :bulk_discounts})
    .where('quantity < bulk_discounts.threshold')
    .sum('quantity * invoice_items.unit_price')
    
    (discounted + full_price) / 100.00
  end
end