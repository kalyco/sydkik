class CreateTopLevelDomains < ActiveRecord::Migration
  def change
    create_table :top_level_domains do |t|
      t.text :domain

      t.timestamps null: false
    end
    add_index :top_level_domains, :domain
  end
end
