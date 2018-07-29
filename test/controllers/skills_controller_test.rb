require 'test_helper'

class SkillsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get skills_url
    assert_response :success
  end
end
