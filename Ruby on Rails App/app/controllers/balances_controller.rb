class BalancesController < ApplicationController
	before_action :create_savon_client
	before_action	:get_current_msisdn
  def index
  	@balance = get_customer_balance
  end


  private

	def get_customer_balance
		return_response = request_to_wsdl_server(:get_balance , @msisdn.contract_id, :get_balance_response)
		return_response[:expiration_date] = return_response[:expiration_date].to_s
		Balance.new(return_response)
		
	end

end
