class Contract < ApplicationRecord
	belongs_to :customer
	has_one :balance
end
