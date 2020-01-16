class CreatePeriods < ActiveRecord::Migration[6.0]
  def change
    create_table :periods do |t|
      t.string :period
      t.integer :month
      t.integer :year
      t.datetime :start_period
      t.datetime :end_period

      t.timestamps
    end
  end
end
