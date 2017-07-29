class SessionsController < ApplicationController
	before_action :create_savon_client
  def new
  	@msisdn = Msisdn.new
  end

  def login	
		@msisdn = Msisdn.new(msisdn_params)
		set_contract_id()
		if @msisdn.contract_id != -1
			redirect_to  controller: 'welcome', action: 'index'
		else
			redirect_to :back , :flash => {:error => 'Telefon Numarası ve ya Parola Hatalı'}
		end
	end

	private

	def set_contract_id
		xml_response = @client.call(:get_contract_id , message: {arg0: @msisdn.msisdn_number , arg1: @msisdn.password})
		response_hash = xml_to_hash(xml_response)
		@msisdn.contract_id  = parse_response_params(response_hash , :get_contract_id_response)
		Msisdn.set_current_msisdn=@msisdn

	end

	def msisdn_params
		params.require(:msisdn).permit(:msisdn_number , :password)
	end
end
