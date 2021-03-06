require 'test_helper'

class TasksControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @task = tasks(:one)
    sign_in users(:user1)
  end

  test "should get index" do
    get tasks_url
    assert_response :success
  end

  test "should get new" do
    get new_task_url
    assert_response :success
  end

  test "should create task" do
    assert_difference('Task.count') do
      post tasks_url, params: { task: { deadline: @task.deadline + 1.days, description: @task.description, name: @task.name, user_id: @task.user_id } }
    end

    assert_redirected_to tasks_url
  end

  test "should get edit" do
    get edit_task_url(@task)
    assert_response :success
  end

  test "should update task" do
    patch task_url(@task), params: { task: { deadline: @task.deadline + 1.days, description: @task.description, name: @task.name, user_id: @task.user_id } }
    assert_redirected_to tasks_url
  end

  test "should update task with state" do
    patch task_url(@task), params: { task: { deadline: @task.deadline + 1.days, description: @task.description, name: @task.name, user_id: @task.user_id }, state: "in_progress" }
    assert_equal @task.current_state, "in_progress"
    assert_redirected_to tasks_url
  end

  test "should destroy task" do
    assert_difference('Task.count', -1) do
      delete task_url(@task)
    end

    assert_redirected_to tasks_url
  end
end
