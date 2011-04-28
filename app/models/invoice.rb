class Invoice < ActiveRecord::Base
  belongs_to :customer  
  belongs_to :project
  has_many :payments
  before_save :textilize
  
  validates_presence_of :invoice_number, :customer, :amount, :description
  validates_uniqueness_of :invoice_number

  def self.default
    return Invoice.new({ :due_date => Date.today + Setting.plugin_chiliproject_invoice['invoice_payment_terms'].to_i.days })
  end
  
  def self.open
    invoices = self.find(:all)
    return invoices.select { |invoice| invoice.open? }
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
    self.description_html = RedCloth3.new(self.description).to_html
  end

  # Is this invoice current but not fully paid?
  def open?
    !fully_paid? && !late?
  end
  
  def fully_paid?
    outstanding <= 0
  end

  def late?
    return false if fully_paid?
    return Time.now > self.due_date
  end
  
  def outstanding
    (total = amount - payments.sum('amount')) > 0 ? total : 0.0
  end

  def self.last_invoice_number
    last_invoice = first(:order => 'id DESC')
    if last_invoice.present?
      last_invoice.invoice_number
    else
      '-'
    end

  end

  if Rails.env.test?
    generator_for :invoice_number, :start => '10000' do |prev|
      prev.succ
    end

    generator_for :amount => 100.0
    generator_for :description => 'This is your test invoice.'
    generator_for :due_date => 1.month.from_now
  end
end
