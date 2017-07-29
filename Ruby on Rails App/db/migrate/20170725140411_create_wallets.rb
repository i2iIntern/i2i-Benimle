class CreateWallets < ActiveRecord::Migration[5.0]
  def change
    create_table :wallets do |t|
      t.integer :amount
      t.integer :customer_id

      t.timestamps
    end
  end
end
