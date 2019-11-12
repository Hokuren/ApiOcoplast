class ProductTreatment < ApplicationRecord
  belongs_to :treatment
  belongs_to :product_treatment_phase
  belongs_to :product_treatment
end
