class RateplansController < ApplicationController
	before_action :create_savon_client
	before_action :get_current_msisdn
  def index
  	@rateplans = get_rateplans
  end


  private
  
	def get_rateplans
		rateplans = []
		xml_response = @client.call(:get_rateplan_list)
		response_hash = xml_to_hash(xml_response)
		return_response = parse_response_params(response_hash , :get_rateplan_list_response)
		return_response.each do |rateplan_params|
			rateplans <<	Rateplan.new(rateplan_params)
		end
		rateplans
	end
end
