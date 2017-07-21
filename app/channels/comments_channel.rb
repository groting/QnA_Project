class CommentsChannel < ApplicationCable::Channel
  def follow(data)
    # stream_from "some_channel"
  end
end
