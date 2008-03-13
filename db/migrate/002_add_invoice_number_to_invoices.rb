# Use rake db:migrate_plugins to migrate installed plugins
class AddInvoiceNumberToInvoices < ActiveRecord::Migration
  def self.up
    add_column :invoices, :invoice_number, :string
  end

  def self.down
    remove_column :invoices, :invoice_number
  end
end
