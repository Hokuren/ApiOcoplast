class ProductTreatmentPhase < ApplicationRecord
  
  belongs_to :phase
  belongs_to :lot

  has_many :product_treatment_phases
  has_many :product_treatments

  accepts_nested_attributes_for :product_treatments 
  
end
