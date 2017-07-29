class CreateCampaigns < ActiveRecord::Migration[5.0]
  def change
    create_table :campaigns do |t|
      t.string :name
      t.string :description
      t.string :rules

      t.timestamps
    end
  end
end
