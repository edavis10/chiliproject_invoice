# Use rake db:migrate_plugins to migrate installed plugins
class CreateInvoicesTable < ActiveRecord::Migration
  def self.up
    create_table :invoices do |t|
      t.column :customer_id, :integer
      t.column :invoiced_on, :datetime
      t.column :amount, :decimal, :precision => 10, :scale => 2
      t.column :description, :text
      t.column :description_html, :text
    end
  end

  def self.down
    drop_table :invoices
  end
end
