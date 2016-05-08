class MathTrade < ActiveRecord::Base
	enum status: [:draft, :active, :pending, :finalized]
	belongs_to :moderator, class_name: "User"
	
	validates_presence_of :name, :offer_deadline, :wants_deadline
	validates_uniqueness_of :name, case_sensitive: false	
end