require 'test_helper'

class AttendancesControllerTest < ActionDispatch::IntegrationTest
  test "should get edit_one_month" do
    get attendances_edit_one_month_url
    assert_response :success
  end

end
