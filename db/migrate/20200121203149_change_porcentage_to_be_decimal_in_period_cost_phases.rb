class ChangePorcentageToBeDecimalInPeriodCostPhases < ActiveRecord::Migration[6.0]
  def change
    change_column :period_cost_phases, :porcentage, :decimal
  end
end
