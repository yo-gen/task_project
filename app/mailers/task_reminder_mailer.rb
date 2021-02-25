class TaskReminderMailer < ApplicationMailer
  default from: "from@task_project.com"

  def notification_email(user, task)
    @user = user
    @task = task
    mail(to: @user.email, subject: 'Task Reminder Notification')
  end
end
