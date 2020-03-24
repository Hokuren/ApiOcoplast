class AddWasteToProdcutTreatmentPhase < ActiveRecord::Migration[6.0]
  def change
    add_column :product_treatment_phases, :waste, :integer
  end
end
