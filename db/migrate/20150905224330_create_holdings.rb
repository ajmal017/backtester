class CreateHoldings < ActiveRecord::Migration
  def change
    create_table :holdings do |t|
      t.float :weight
      t.references :security, index: true, foreign_key: true
      t.references :portfolio, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
