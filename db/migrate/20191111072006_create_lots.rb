class CreateLots < ActiveRecord::Migration[6.0]
  def change
    create_table :lots do |t|
      t.numeric :cost
      t.numeric :weight
      t.numeric :waste
      t.numeric :available
    
      t.timestamps
    end
  end
end
