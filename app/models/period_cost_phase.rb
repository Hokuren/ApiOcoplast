class PeriodCostPhase < ApplicationRecord
  belongs_to :period
  belongs_to :cost
  belongs_to :phase
end
