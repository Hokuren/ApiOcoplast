class CreateProductTreatments < ActiveRecord::Migration[6.0]
  def change
    create_table :product_treatments do |t|
      t.numeric :cost
      t.numeric :weight
      t.numeric :waste
      t.numeric :digits_quantity
      t.references :treatment, null: false, foreign_key: true
      t.references :product_treatment_phase, null: false, foreign_key: true
      t.references :product_treatment, null: true, foreign_key: true

      t.timestamps
    end
  end
end
