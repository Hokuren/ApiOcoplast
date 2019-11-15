class Treatment < ApplicationRecord
    has_many :product_treatments
    
    accepts_nested_attributes_for :product_treatments
   
end
