class CreateMetros < ActiveRecord::Migration
  def change
    create_table :metros do |t|
      t.string :name

      t.timestamps null: false
    end

    add_index :metros, :name

    add_column :zipcodes, :metro_id, :integer

    add_index :zipcodes, :metro_id
  end
end
