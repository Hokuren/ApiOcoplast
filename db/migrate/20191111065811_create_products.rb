class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name
      t.numeric :cost
      t.numeric :weight
      t.references :product, null: true, foreign_key: true

      t.timestamps
    end
  end
end

