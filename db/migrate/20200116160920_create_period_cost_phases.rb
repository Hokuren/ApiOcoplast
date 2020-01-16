class CreatePeriodCostPhases < ActiveRecord::Migration[6.0]
  def change
    create_table :period_cost_phases do |t|
      t.string :type_cost
      t.integer :cost
      t.integer :cost_porcentage
      t.integer :porcentage
      t.references :period, null: false, foreign_key: true
      t.references :cost, null: false, foreign_key: true
      t.references :phase, null: false, foreign_key: true

      t.timestamps
    end
  end
end
