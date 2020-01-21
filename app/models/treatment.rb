class Treatment < ApplicationRecord
    has_many :product_treatments
    
    accepts_nested_attributes_for :product_treatments
   
    #scope :find_or_create, -> (treatment_new_name) {
    #   .where("name LIKE ?", "%#{treatment_new_name}%").last
    #}
    
end
