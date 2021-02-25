class EmailReminderJob < ActiveJob::Base
  queue_as :default

  def perform(user_id, task_id)
    user = User.find_by(id: user_id)
    task = Task.find_by(id: task_id)
    return if user.nil? || task.nil?
    return if task.in_state?(:done)

    TaskReminderMailer.notification_email(user, task).deliver!
  end
end
