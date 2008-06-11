class Invoice < ActiveRecord::Base
  belongs_to :customer  
  has_many :payments
  before_save :textilize
  
  validates_presence_of :invoice_number, :customer, :amount, :description
  validates_uniqueness_of :invoice_number
  
  def textilize
    self.description_html = RedCloth.new(self.description).to_html
  end
end
