module AnswersHelper
  def vote(answer)
    answer.vote(current_user)
  end
end
