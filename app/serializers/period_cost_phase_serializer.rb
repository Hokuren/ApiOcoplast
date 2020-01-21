class PeriodCostPhaseSerializer < ActiveModel::Serializer
  attributes :id, :type_cost, :cost, :cost_porcentage, :porcentage
  has_one :period
  has_one :cost
  has_one :phase
end
