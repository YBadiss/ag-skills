require 'test_helper'

class SkillsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get skills_url
    assert_response :success
  end

  test "should get show" do
    get skill_url(id: 1)
    assert_response :success
  end
end
