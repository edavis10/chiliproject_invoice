class CreateInvoiceTimeEntries < ActiveRecord::Migration
  def self.up
    create_table :invoice_time_entries do |t|
      t.references :invoice
      t.references :time_entry
    end
  end

  def self.down
    drop_table :invoice_time_entries
  end
end
