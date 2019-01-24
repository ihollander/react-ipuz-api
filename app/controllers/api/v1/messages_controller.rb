class Api::V1::MessagesController < ApplicationController
  before_action :find_game

  def create
    @message = @game.messages.create(message_params.merge(user: @user))
    if @message.valid?
      payload = ActiveModelSerializers::Adapter::Json.new(
        MessageSerializer.new(@message)
      ).serializable_hash

      GamesChannel.broadcast_to(@game, {
        type: 'NEW_MESSAGE',
        payload: payload
      })
      render json: @message
    else
      render json: { errors: @message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    @messages = @game.messages
    render json: @messages
  end

  private

  def find_game
    @game = Game.find_by(id: params[:game_id])
  end

  def message_params
    params.permit(:text)
  end

end
