require 'test_helper'

class CampaignsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get campaigns_index_url
    assert_response :success
  end

end
