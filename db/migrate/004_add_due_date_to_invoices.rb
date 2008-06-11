# Use rake db:migrate_plugins to migrate installed plugins
class AddDueDateToInvoices < ActiveRecord::Migration
  def self.up
    add_column :invoices, :due_date, :datetime
    
    Invoice.reset_column_information
    
    terms = Setting.plugin_invoice_plugin['invoice_payment_terms'].to_i || 30
    
    Invoice.find(:all).each do |invoice|
      invoice.update_attribute(:due_date, invoice.invoiced_on + terms.days)
    end
  end

  def self.down
    remove_column :invoices, :due_date
  end
end
