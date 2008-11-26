class Invoice < ActiveRecord::Base
  belongs_to :customer  
  belongs_to :project
  has_many :payments
  before_save :textilize
  
  validates_presence_of :invoice_number, :customer, :amount, :description
  validates_uniqueness_of :invoice_number

  def self.default
    return Invoice.new({ :due_date => Date.today + Setting.plugin_invoice_plugin['invoice_payment_terms'].to_i.days })
  end
  
  def self.open
    invoices = self.find(:all)
    return invoices.select { |invoice| !invoice.fully_paid? && !invoice.late? }
  end
  
  def self.late
    invoices = self.find(:all)
    return invoices.select { |invoice| invoice.late? }
  end
  
  def self.closed
    invoices = self.find(:all)
    return invoices.select { |invoice| invoice.fully_paid? }
  end
  
  def textilize
    self.description_html = RedCloth.new(self.description).to_html
  end
  
  def fully_paid?
    total_paid = self.payments.collect(&:amount).sum
    return total_paid >= self.amount
  end

  def late?
    return false if fully_paid?
    return Time.now > self.due_date
  end
  
  def outstanding
    self.amount - self.payments.collect(&:amount).sum
  end
  
end
