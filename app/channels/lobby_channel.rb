class LobbyChannel < ApplicationCable::Channel
  def subscribed
    ActionCable.server.broadcast('lobby_channel', {
      type: 'USER_ENTERED_LOBBY',
      payload: current_user
    })
    stream_from "lobby_channel"
  end

  def unsubscribed
    ActionCable.server.broadcast('lobby_channel', {
      type: 'USER_LEFT_LOBBY',
      payload: current_user
    })
  end
end
