require 'test_helper'

class SkillTest < ActiveSupport::TestCase
  test "should list top_level skills" do
    top_levels = Skill.top_level

    assert_equal(top_levels, skills(:football, :basketball, :rugby))
  end

  test "should validate uniqueness of skill name" do
    bad_skill = Skill.new(name: skills(:football).name)

    assert_equal(false, bad_skill.valid?)
  end

  test "should validate depth of skill tree" do
    bad_skill = Skill.new(name: 'SomeSkill', parent: skills(:foot))

    assert_equal(false, bad_skill.valid?)
  end

  test "should list users" do
    actual_users = skills(:football).users.to_a
    expected_users = [users(:football_user)]

    assert_equal(expected_users, actual_users)
  end

  test "should list own and children users" do
    actual_users = skills(:football).all_users
    expected_users = users(:football_user, :foot_user)

    assert_equal(expected_users, actual_users)
  end

  [:rails_summary, :sql_summary].each do |summary_fn|
    test "should produce correct #{summary_fn}" do
      expected_summary = [
          {
              id: 1,
              name: 'Football',
              users_count: 2,
              points: 25
          },
          {
              id: 2,
              name: 'Basketball',
              users_count: 2,
              points: 20
          },
          {
              id: 3,
              name: 'Rugby',
              users_count: 0,
              points: 0
          }
      ].map(&:with_indifferent_access)
      actual_summary = Skill.send(summary_fn)

      assert_equal(expected_summary, actual_summary)
    end
  end
end
