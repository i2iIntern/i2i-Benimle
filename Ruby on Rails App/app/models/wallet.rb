class Wallet < ApplicationRecord
	has_many :msisdns
	accepts_nested_attributes_for :msisdns
end
