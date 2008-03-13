class Invoice < ActiveRecord::Base
  belongs_to :customer
  
  before_save :textilize
  
  def textilize
    self.description_html = RedCloth.new(self.description).to_html
  end
end
