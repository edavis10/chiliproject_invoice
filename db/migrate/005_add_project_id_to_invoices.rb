class AddProjectIdToInvoices < ActiveRecord::Migration
  def self.up
    add_column :invoices, :project_id, :integer
  end

  def self.down
    remove_column :invoices, :project_id
  end
end
