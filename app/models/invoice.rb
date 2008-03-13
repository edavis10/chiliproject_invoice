class Invoice < ActiveRecord::Base
  belongs_to :customer
end
