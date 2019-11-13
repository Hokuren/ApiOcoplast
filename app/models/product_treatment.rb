class ProductTreatment < ApplicationRecord
  belongs_to :treatment
  belongs_to :product_treatment_phase
  has_many :product_treatments

end
