class CreateBggItemDataRanks < ActiveRecord::Migration
  def change
    create_table :bgg_item_data_ranks do |t|
	    t.references :bgg_item_data, index: true, null: false
	    t.string :rank_type
	    t.string :name
	    t.string :friendly_name
	    t.integer :value
	    t.float :bayes
	    t.timestamps null: false
    end
    
    add_foreign_key :bgg_item_data_ranks, :bgg_item_data
  end
end
