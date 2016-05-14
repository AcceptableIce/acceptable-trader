class WantGroup < ActiveRecord::Base
	belongs_to :user
	belongs_to :math_trade
	
	has_many :want_items, class_name: "WantGroupItem", :dependent => :destroy
	has_many :want_links, class_name: "WantGroupLink", :dependent => :destroy
	
	validates_length_of :name, within: 1..64
	validates_uniqueness_of :name, scope: [:math_trade_id, :user_id]
	
	validates_length_of :short_name, within: 1..8
	validates_uniqueness_of :short_name, scope: [:math_trade_id, :user_id]
	validates_format_of :short_name, with: /[a-zA-Z0-9]+/
	
	validates_presence_of :name, :short_name
end