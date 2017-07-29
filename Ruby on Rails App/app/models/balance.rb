class Balance < ApplicationRecord
	belongs_to :msisdn
	belongs_to :contract
end
