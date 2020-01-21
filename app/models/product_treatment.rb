class ProductTreatment < ApplicationRecord
  belongs_to :treatment
  belongs_to :product_treatment_phase
  has_many :product_treatments

  has_many :treatments
  accepts_nested_attributes_for :treatments



end
