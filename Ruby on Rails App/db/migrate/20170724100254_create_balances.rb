class CreateBalances < ActiveRecord::Migration[5.0]
  def change
    create_table :balances do |t|
      t.integer :remaining_data
      t.integer :remaining_voice
      t.integer :remaining_sms
      t.integer :msisdn_id
      t.integer :contract_id

      t.timestamps
    end
  end
end
