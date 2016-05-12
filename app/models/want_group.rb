class WantGroup < ActiveRecord::Base
	belongs_to :user
	belongs_to :math_trade
	
	has_many :want_items, class_name: "WantGroupItem", :dependent => :destroy
	has_many :want_links, class_name: "WantGroupLink", :dependent => :destroy
end