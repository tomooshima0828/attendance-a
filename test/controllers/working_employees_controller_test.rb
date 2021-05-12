require 'test_helper'

class WorkingEmployeesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get working_employees_index_url
    assert_response :success
  end

end
