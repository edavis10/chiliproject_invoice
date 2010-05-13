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

  context "#outstanding" do
    setup do
      customer = Customer.create!(:name => 'customer')
      @invoice = Invoice.generate!(:amount => 100.0, :customer => customer)
    end
    
    should "return the total unpaid amount left on an invoice" do
      Payment.generate!(:amount => 10, :invoice => @invoice)

      assert_equal @invoice.amount - 10, @invoice.outstanding
    end
    
    should "return 0.0 if the invoice is fully paid" do
      Payment.generate!(:amount => @invoice.amount, :invoice => @invoice)

      assert_equal 0.0, @invoice.outstanding
    end
    
    should "return 0.0 if the invoice is over paid" do
      Payment.generate!(:amount => @invoice.amount + 25.0, :invoice => @invoice)

      assert_equal 0.0, @invoice.outstanding
    end
    
    should "return the base amount if there are no payments" do
      assert_equal @invoice.amount, @invoice.outstanding
    end
  end

  context "#fully_paid?" do
    setup do
      customer = Customer.create!(:name => 'customer')
      @invoice = Invoice.generate!(:amount => 100.0, :customer => customer)
    end
    
    should "return false if the outstanding amount is greater than 0" do
      Payment.generate!(:amount => 10, :invoice => @invoice)

      assert !@invoice.fully_paid?
    end
    
    should "return true if the outstanding amount is less than 0" do
      Payment.generate!(:amount => @invoice.amount + 10, :invoice => @invoice)

      assert @invoice.fully_paid?
    end

    should "return true if the outstanding amount is equal to 0" do
      Payment.generate!(:amount => @invoice.amount, :invoice => @invoice)

      assert @invoice.fully_paid?
    end

  end
end
