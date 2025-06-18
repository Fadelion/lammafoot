class CreateStadia < ActiveRecord::Migration[8.0]
  def change
    create_table :stadia do |t|
      t.string :name
      t.string :location
      t.decimal :price
      t.integer :capacity
      t.text :description

      t.timestamps
    end
  end
end
