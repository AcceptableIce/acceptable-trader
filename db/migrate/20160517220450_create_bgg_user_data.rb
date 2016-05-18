class CreateBggUserData < ActiveRecord::Migration
  def change
    create_table :bgg_user_data do |t|
	    t.string :name
	    t.string :avatar
	    t.integer :year_registered
	    t.string :state
	    t.integer :trade_rating
	    t.timestamps null: false
    end
  end
end
