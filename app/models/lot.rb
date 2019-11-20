class Lot < ApplicationRecord
  has_many :product_treatment_phases
  has_many :quantities
end
