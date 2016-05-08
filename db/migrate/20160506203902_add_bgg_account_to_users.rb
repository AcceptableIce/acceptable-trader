class AddBggAccountToUsers < ActiveRecord::Migration
  def change
	  add_column :users, :bgg_account, :string, after: :last_sign_in_ip
	  add_column :users, :bgg_account_verification_code, :string, after: :bgg_account
	  add_column :users, :bgg_account_verified, :boolean, after: :bgg_account_verification_code, null: false, default: false
  end
end
