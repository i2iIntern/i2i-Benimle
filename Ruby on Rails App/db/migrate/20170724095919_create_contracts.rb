class CreateContracts < ActiveRecord::Migration[5.0]
  def change
    create_table :contracts do |t|
      t.string :secret_question
      t.string :secret_answer
      t.integer :customer_id

      t.timestamps
    end
  end
end
