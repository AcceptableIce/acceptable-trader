class CreateMathTradeTable < ActiveRecord::Migration
  def change
    create_table :math_trades do |t|
	    t.string :name, null: false
	    t.references :moderator, references: :user, index: true, null: false
	    t.text :description
	    t.integer :status, null: false, default: 0
	    t.datetime :offer_deadline, null: false
	    t.datetime :wants_deadline, null: false
	    t.boolean :shipping, null: false, default: false
	    t.integer :discussion_thread
	    t.timestamps null:false
    end
    
    add_foreign_key :math_trades, :users, column: :moderator_id
  end
end
