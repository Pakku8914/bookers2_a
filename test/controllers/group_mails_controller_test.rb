require "test_helper"

class GroupMailsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get group_mails_new_url
    assert_response :success
  end
end
