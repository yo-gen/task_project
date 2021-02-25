class TaskStateMachine
  include Statesman::Machine

  state :backlog, initial: true
  state :in_progress
  state :done

  transition from: :backlog, to: [:in_progress, :done]
  transition from: :in_progress, to: [:backlog, :done]

  #before_transition(from: :checking_out, to: :cancelled) do |order, transition|
  #  order.reallocate_stock
  #end
  #
  #before_transition(to: :purchased) do |order, transition|
  #  PaymentService.new(order).submit
  #end
  #
  #after_transition(to: :purchased) do |order, transition|
  #  MailerService.order_confirmation(order).deliver
  #end
end