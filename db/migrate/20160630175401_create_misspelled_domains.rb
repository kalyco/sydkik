class CreateMisspelledDomains < ActiveRecord::Migration
  def change
    create_table :misspelled_domains do |t|
      t.text :domain

      t.timestamps null: false
    end
    add_index :misspelled_domains, :domain
  end
end
