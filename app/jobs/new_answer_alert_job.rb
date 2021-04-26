class NewAnswerAlertJob < ApplicationJob
  queue_as :default

  def perform(question)
    NotificationService.new.new_answer(question)
  end
end
