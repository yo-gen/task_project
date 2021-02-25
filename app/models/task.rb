class Task < ApplicationRecord
  belongs_to :user

  validates :name, :deadline, presence: true
  validate :deadline_cannot_be_in_the_past, on: :create

  after_create :schedule_reminders

  has_many :transitions, class_name: 'TaskTransition', autosave: false

  include Statesman::Adapters::ActiveRecordQueries[
    transition_class: TaskTransition,
    initial_state: :backlog
  ]

  delegate :can_transition_to?, :current_state, :history, :last_transition,
           :transition_to!, :transition_to, :in_state?, to: :state_machine

  def state_machine
    @state_machine ||= TaskStateMachine.new(self, transition_class: TaskTransition,
                                            association_name: 'transitions')
  end

  def deadline_cannot_be_in_the_past
    if deadline.present? && deadline < (Time.now + 1.hour)
      errors.add(:deadline, 'should be at least 1 hours from now')
    end
  end

  def schedule_reminders
    EmailReminderJob.set(wait_until: self.deadline - 1.hours).perform_later(self.id)
    EmailReminderJob.set(wait_until: self.deadline - 24.hours).perform_later(self.id)
  end
end
