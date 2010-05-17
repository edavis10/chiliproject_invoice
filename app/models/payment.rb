class Payment < ActiveRecord::Base
  belongs_to :invoice  
  
  validates_presence_of :invoice, :amount, :applied_on
  validates_numericality_of :amount

  if Rails.env.test?
    generator_for :applied_on => Date.today
  end
end
