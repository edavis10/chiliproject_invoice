class Payment < ActiveRecord::Base
  belongs_to :invoice  
  
  validates_presence_of :invoice, :amount, :applied_on
  validates_numericality_of :amount
end
