require 'test_helper'

class BalancesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get balances_index_url
    assert_response :success
  end

end
