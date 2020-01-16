class Phase < ApplicationRecord
    has_many :product_treatment_phases 
    has_many :period_cost_phases

end
