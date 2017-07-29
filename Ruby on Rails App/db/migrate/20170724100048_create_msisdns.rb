class CreateMsisdns < ActiveRecord::Migration[5.0]
  def change
    create_table :msisdns do |t|
      t.string :msisdn_number
      t.string :password
      t.integer :contract_id
      t.integer :balance_id
      t.integer :rateplan_id

      t.timestamps
    end
  end
end
