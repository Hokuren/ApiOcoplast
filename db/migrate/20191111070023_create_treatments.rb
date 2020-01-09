class CreateTreatments < ActiveRecord::Migration[6.0]
  def change
    create_table :treatments do |t|
      t.string :name
      t.numeric :minimal_cost
      t.numeric :maximum_cost
      t.timestamps
    end
  end
end
