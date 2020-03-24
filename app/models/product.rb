class Product < ApplicationRecord
    ##validates :product_id, presence: true 

    has_many :quantities
    has_many :product_treatment_phases
end
