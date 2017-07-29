class CampaignsController < ApplicationController
	before_action :create_savon_client
	before_action :get_current_msisdn
  def index
  	@campaigns = get_campaigns
  end


  private

	def get_campaigns
		campaigns = []
		xml_response = @client.call(:get_campaign)
		response_hash = xml_to_hash(xml_response)
		return_response = parse_response_params(response_hash , :get_campaign_response)
		return_response.each do |campaign_params|
			campaigns <<	Campaign.new(campaign_params)
		end
		campaigns		
	end

end
