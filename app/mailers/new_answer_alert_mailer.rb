class NewAnswerAlertMailer < ApplicationMailer
  def new_answer(question)

    question.subscribers.find_each do |user|
      email to: user.email
  end
end
