require File.dirname(__FILE__) + '/../test_helper'

class InvoiceTest < ActiveSupport::TestCase
  should_belong_to :customer
  should_belong_to :project
  should_have_many :payments

  should_validate_presence_of :invoice_number
  should_validate_presence_of :customer
  should_validate_presence_of :amount
  should_validate_presence_of :description

  context "#open" do
    should "only return open invoices" do
      customer = Customer.create!(:name => 'customer')
      open1 = Invoice.generate!(:customer => customer)
      open2 = Invoice.generate!(:customer => customer)
      paid = Invoice.generate!(:amount => 100.0, :customer => customer)
      Payment.generate!(:amount => 100.0, :invoice => paid)

      open_invoices = Invoice.open
      assert open_invoices.all? {|invoice| invoice.open? }
      assert_contains open_invoices, open1
      assert_contains open_invoices, open2
    end
  end
end
