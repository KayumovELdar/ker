class NewAnswerAlertService
  def new_answer(question)
    NewAnswerAlertService.new_answer(question).deliver_later
  end
end
