class Msisdn < ApplicationRecord
	belongs_to :rateplan
	belongs_to :contract
	has_one :balance
	belongs_to :wallet
	validates_length_of :msisdn_number , :minimum => 11 , :maximum => 11
	def self.set_current_msisdn=(cm)
		@current_msisdn = cm
	end

	def self.get_current_msisdn
		@current_msisdn
	end
end
