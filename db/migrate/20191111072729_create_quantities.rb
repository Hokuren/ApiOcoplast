class CreateQuantities < ActiveRecord::Migration[6.0]
  def change
    create_table :quantities do |t|
      t.numeric :cost
      t.numeric :weight
      t.numeric :weight_initial
      t.datetime :date 
      t.references :product, null: false, foreign_key: true
      t.references :lot, null: false, foreign_key: true

      t.timestamps
    end
  end
end
