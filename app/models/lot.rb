class Lot < ApplicationRecord
  has_many :product_treatment_phases
  has_many :quantities

  scope :by_product_treatment_phase, -> (phase_id){
    joins(:product_treatment_phases)
    .where(product_treatment_phases: { id: phase_id })
    .last
  }

end
