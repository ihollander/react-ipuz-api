class SharedGamesChannel < ApplicationCable::Channel
  def subscribed
    game = SharedGame.find_by(id: params[:id])
    stream_for game
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
