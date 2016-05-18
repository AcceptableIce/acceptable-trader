class AddBggItemData < ActiveRecord::Migration
 def change
    create_table :bgg_item_data do |t|
			t.string :item_type
			t.string :image
			t.string :thumbnail
			t.string :name
			t.text :description
			t.integer :year_published
			t.integer :min_players
			t.integer :max_players
			t.integer :playing_time
			t.integer :min_playing_time
			t.integer :max_playing_time
			t.integer :user_ratings
			t.float :average
			t.float :bayes
			t.float :stddev
			t.float :median
			t.integer :owned
			t.integer :trading
			t.integer :wanting
			t.integer :wishing
			t.integer :num_comments
			t.integer :num_weights
			t.integer :average_weight
			t.timestamps null: false
    end
    
  end

end
