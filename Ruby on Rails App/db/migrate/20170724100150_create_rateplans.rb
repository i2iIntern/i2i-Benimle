class CreateRateplans < ActiveRecord::Migration[5.0]
  def change
    create_table :rateplans do |t|
      t.string :name
      t.string :description
      t.integer :price
      t.integer :data_amount
      t.integer :voice_amount
      t.integer :sms_amount

      t.timestamps
    end
  end
end
