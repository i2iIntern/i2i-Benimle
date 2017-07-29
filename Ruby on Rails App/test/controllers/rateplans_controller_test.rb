require 'test_helper'

class RateplansControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get rateplans_index_url
    assert_response :success
  end

end
