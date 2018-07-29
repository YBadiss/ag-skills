require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should validate presence of skill" do
    bad_user = User.new(points: 10)

    assert_equal(false, bad_user.valid?)
  end

  test "should validate presence of points" do
    bad_user = User.new(skill: skills(:football))

    assert_equal(false, bad_user.valid?)
  end
end
