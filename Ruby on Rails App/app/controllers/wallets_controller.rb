class WalletsController < ApplicationController
  before_action :create_savon_client
  before_action :get_current_msisdn
  before_action :parse_params , only: [:add_balance]
  def index
  	@wallet = Wallet.new
    @msisdn_wallet = Msisdn.new
  end

  def add_balance
    xml_response = @client.call(:update_customer_wallet , message: {arg0: @parsed_params["amount"] , arg1: @parsed_params["msisdn_number"]})
    redirect_to welcome_index_path
  end


  private



  def parse_params
    @parsed_params = {}
    @parsed_params["amount"] = params["wallet"]["amount"]
    @parsed_params["msisdn_number"] =params["wallet"]["msisdn"]["msisdn_number"]
    @parsed_params
  end

end
