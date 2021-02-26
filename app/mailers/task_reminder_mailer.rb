class TaskReminderMailer < ApplicationMailer
  default from: "in.yogen@gmail.com"

  def notification_email(user, task)
    @user = user
    @task = task
    mail(to: @user.email, subject: 'Task Reminder Notification')
  end
end
