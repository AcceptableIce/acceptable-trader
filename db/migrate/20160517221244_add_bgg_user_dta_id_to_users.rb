class AddBggUserDtaIdToUsers < ActiveRecord::Migration
  def change
	  add_reference :users, :bgg_user_data, index: true, null: true, after: :bgg_account
	  add_foreign_key :users, :bgg_user_data
  end
end
