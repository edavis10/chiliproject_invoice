# Use rake db:migrate_plugins to migrate installed plugins
class CreatePaymentsTable < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.column :invoice_id, :integer
      t.column :amount, :decimal, :precision => 10, :scale => 2
      t.column :note, :text
      t.column :applied_on, :date
    end
  end

  def self.down
    drop_table :payments
  end
end
