require 'bgg'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  after_create :send_validation_message
  validates_uniqueness_of :bgg_account, case_sensitive: false, message: "is already linked to another user."
         
  def bgg_user
	  if verified?
		  return BGGUser.find(bgg_account)
		else
			return nil
		end
	end
	
	def verified?
		return bgg_account_verified == true
	end
	
	def get_collection(filter = {})
		raw_collection = get_raw_collection()
		new_collection = []
		if !new_collection.nil?
			raw_collection["item"].each do |item|
				matched = true
				status = item["status"][0];
				filter.each do |key, value|
					if status[key.to_s].to_i != value
						matched = false
					end
				end
				
				if matched 
					new_collection.push({
						id: item["objectid"],
						type: item["subtype"],
						name: item["name"][0]["content"],
						year: item["yearpublished"],
						image: item["image"][0],
						thumbnail: item["thumbnail"][0],
						status: status
					})
				end
			end
		end
		return new_collection
	end
	
	def get_owned
		return get_collection({ own: 1 })	
	end
	
	def get_for_trade
		return get_collection({ fortrade: 1 })
	end
	
	def get_wishlist
		return get_collection({ wishlist: 1 })
	end
	
	def get_previously_owned
		return get_collection({ prevowned: 1 })
	end
	
	def get_want_to_play
		return get_collection({ wanttoplay: 1})
	end
	
	def get_want_to_buy
		return get_collection({ wanttobuy: 1 })
	end
	
	def get_want_in_trade
		return get_collection({ want: 1})
	end
	
	private
	
	def get_raw_collection(filter = {})
		value = Rails.cache.fetch("user_#{id}/collection");
		if value.nil?
			value = Rails.cache.fetch("user_#{id}/collection", expires_in: 12.hours) do
				bgg_user_ref = bgg_user
				if !bgg_user_ref.nil?
					filter["username"] = bgg_account
					attempts = 0
					collection = nil
					while(collection.nil? && attempts < 5)
						suppress(Exception) do 
							collection =  BggApi.collection(filter)
						end
						attempts += 1
					end
					collection ? collection : []
				else
					nil
				end
			end
		end
		return value
	end
	
	def send_validation_message
		link = "http://localhost:3000/bgg/verify_user_account?key=#{bgg_account_verification_code}"
		BGGUser.find(bgg_account).send_mail(
			"Link your BGG Account to Math Trade Manager",
			"Heya, #{bgg_account}.\n\nWe've gotten a request to link your BGG account with the Math Trade Manager. " +
			"Just click the link below and we'll wire it all up.\n\n
			#{link}\n\n
			Thanks,\n
			The Math Trade Mnager Team"
		)
	end
		
end
