class AddExpirationDateToBalance < ActiveRecord::Migration[5.0]
  def change
    add_column :balances, :expiration_date, :string
  end
end
