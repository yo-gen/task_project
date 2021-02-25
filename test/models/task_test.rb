require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  test "should not save task without name" do
    task = Task.new(description: "This is first task", deadline: Time.now, user: users(:user1))
    assert_not task.save
  end

  test "should not save task without deadline" do
    task = Task.new(name: "New task", description: "This is first task", user: users(:user1))
    assert_not task.save
  end

  test "should save task with name and deadline in past" do
    task = Task.new(name: "New Task", deadline: Time.now - 2.hours, user: users(:user1))
    assert_not task.save
  end

  test "should save task with name and deadline in future" do
    task = Task.new(name: "New Task", deadline: Time.now + 2.hours, user: users(:user1))
    assert task.save
  end
end
