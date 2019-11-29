class Product < ApplicationRecord
    has_many :quantities
    has_many :product_treatment_phases
end
