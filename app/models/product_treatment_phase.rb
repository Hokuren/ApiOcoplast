class ProductTreatmentPhase < ApplicationRecord
  
  belongs_to :phase
  belongs_to :lot
  belongs_to :product
  #belongs_to :product_treatment_phase, optional: true

  has_many :product_treatment_phases
  has_many :product_treatments

  accepts_nested_attributes_for :product_treatments 
  

  scope :last_by_product_per_phase, -> (product_id,phase_id_previous) { 
    where( product_id: product_id, phase_id: phase_id_previous ).last
  }
 


end
