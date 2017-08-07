class AnswerNoticeJob < ApplicationJob
  queue_as :default

  def perform(answer)
    answer.question.subscriptions.find_each do |subscription|
      SubscriptionMailer.notice(subscription.user, resource: answer).deliver_later
    end
  end
end
