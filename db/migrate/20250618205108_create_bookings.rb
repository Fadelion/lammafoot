class CreateBookings < ActiveRecord::Migration[8.0]
  def change
    create_table :bookings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :stadium, null: false, foreign_key: true
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.string :status, default: 'confirmed'

      t.timestamps
    end

     add_index :bookings, [:pitch_id, :start_time, :end_time], unique: true
  end
end

