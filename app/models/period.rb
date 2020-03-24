class Period < ApplicationRecord

  has_many :period_cost_phases
  has_many :costs, through: :period_cost_phases

end
