class CreateSecurities < ActiveRecord::Migration
  def change
    create_table :securities do |t|
      t.string :name
      t.string :ticker
      t.string :identifier

      t.timestamps null: false
    end
  end
end
