class WelcomeController < ApplicationController
	before_action :create_savon_client
	before_action :get_current_msisdn
	def index
		@wallet = get_customer_wallet
		@customer = get_customer_credentials
		@customer_rateplan = get_customer_rateplan
	end

	private

	def get_customer_wallet
		return_response = request_to_wsdl_server(:get_customer_wallet , @msisdn.contract_id , :get_customer_wallet_response)
		Wallet.new(return_response)
	end

	def get_customer_rateplan
		return_response = request_to_wsdl_server(:get_rateplan ,@msisdn.contract_id , :get_rateplan_response )
		Rateplan.new(return_response)
	end

	def get_customer_credentials
		return_response = request_to_wsdl_server(:get_customer_credential ,@msisdn.contract_id , :get_customer_credential_response )
		Customer.new(return_response)
	end
end
