class Lot < ApplicationRecord
  belongs_to :product_treatment_phase
  has_many :quantities
end
