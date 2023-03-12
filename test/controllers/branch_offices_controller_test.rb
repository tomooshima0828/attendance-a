# frozen_string_literal: true

require 'test_helper'

class BranchOfficesControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get branch_offices_index_url
    assert_approval :success
  end
end
