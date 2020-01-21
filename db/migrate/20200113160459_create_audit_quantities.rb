class CreateAuditQuantities < ActiveRecord::Migration[6.0]
  def change
    create_table :audit_quantities do |t|
      t.integer :cost
      t.integer :weight
      t.integer :weight_initial
      t.datetime :date
      t.references :product, null: false, foreign_key: true
      t.references :lot, null: false, foreign_key: true
      t.references :quantity, null: false, foreign_key: true

      t.timestamps
    end
  end
end
