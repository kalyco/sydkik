class CreateZipcodes < ActiveRecord::Migration
  def change
    create_table :zipcodes do |t|
      t.text :zip
      t.decimal :lat
      t.decimal :long
      t.text :city
      t.text :state
      t.text :county

      t.timestamps null: false
    end
  end
end
