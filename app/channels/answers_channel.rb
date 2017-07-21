class AnswersChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "question_#{data['question_id']}_answers"
  end
end
