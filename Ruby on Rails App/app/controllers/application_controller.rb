class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception


  protected

	def create_savon_client
		@client = Savon.client do
  		wsdl "http://172.30.10.7:9090/i2i_benimle?wsdl"
		end
	end

	def get_current_msisdn
		@msisdn = Msisdn.get_current_msisdn
	end

	def parse_response_params(param_hash , hash_key)
		param_hash[hash_key][:return]
	end

	def request_to_wsdl_server(function_name , function_param , requested_hash)
		xml_response = @client.call(function_name , message: {arg0: function_param})
		response_hash = xml_to_hash(xml_response)
		return_response = parse_response_params(response_hash , requested_hash)
	end

	def xml_to_hash(xml_data)
		hash_response =  xml_data.to_hash
	end
end
