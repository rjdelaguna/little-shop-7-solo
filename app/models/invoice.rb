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
    .select('invoice_items.*, max(bulk_discounts.percentage) as highest_percentage')
    .group(:id)
    .sum { |each| ((each.quantity * each.unit_price) * (1.0 - (each.highest_percentage / 100.00)) / 100.0)}

    full_price = invoice_items
    .joins(item: {merchant: :bulk_discounts})
    .select('distinct invoice_items.*, (quantity * invoice_items.unit_price) as revenue, min(bulk_discounts.threshold) as lowest_threshold')
    .group(:id)
    .sum do |each| 
      if each.lowest_threshold > each.quantity
        each.revenue / 100.0
      else
        0
      end
    end
    
    discounted + full_price
  end
end