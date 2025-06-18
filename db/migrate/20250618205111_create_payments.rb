class CreatePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :payments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :booking, null: false, foreign_key: true
      t.decimal :amount
      t.datetime :payment_date
      t.string :payment_method
      t.string :status

      t.timestamps
    end
  end
end
