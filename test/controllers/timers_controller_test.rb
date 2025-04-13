require "test_helper"

class TimersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get timers_index_url
    assert_response :success
  end

  test "should get create" do
    get timers_create_url
    assert_response :success
  end

  test "should get complete" do
    get timers_complete_url
    assert_response :success
  end
end
