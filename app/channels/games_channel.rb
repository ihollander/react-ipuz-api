class GamesChannel < ApplicationCable::Channel
  
  def subscribed
    @game = Game.find_by(id: params[:game_id])
    @game.set_user_active(current_user, true)
    GamesChannel.broadcast_to(@game, {
      type: 'USER_ENTERED_GAME',
      payload: current_user.actioncable_serialize
    })
    ActionCable.server.broadcast('lobby_channel',
      type: 'GAME_UPDATED',
      payload: @game.actioncable_small_serialize)
    stream_for @game
  end

  def unsubscribed
    @game.set_user_active(current_user, false)
    GamesChannel.broadcast_to(@game, {
      type: 'USER_LEFT_GAME',
      payload: current_user.actioncable_serialize
    })
    ActionCable.server.broadcast('lobby_channel',
      type: 'GAME_UPDATED',
      payload: @game.actioncable_small_serialize)
  end
end