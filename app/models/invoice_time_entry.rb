class InvoiceTimeEntry < ActiveRecord::Base
  unloadable
  
  belongs_to :invoice
  belongs_to :time_entry
end
