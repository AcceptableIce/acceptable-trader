class MathTrade < ActiveRecord::Base
	
	enum status: [:draft, :active, :pending, :finalized]
	belongs_to :moderator, class_name: "User"
	has_many :items, -> {order 'position asc' }, class_name: "MathTradeItem"
	has_many :wants, class_name: "MathTradeWant"
	
	acts_as_paranoid
	
	validates_presence_of :name, :offer_deadline, :wants_deadline
	validates_uniqueness_of :name, case_sensitive: false	
		
	def items_from_user(user)
		items.select { |x| x["user_id"] == user.id }
	end

	def get_user_wantlist(user)
		wants.where(user_id: user.id)
	end
end