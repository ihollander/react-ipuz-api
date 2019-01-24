# frozen_string_literal: true

class Api::V1::GamesController < ApplicationController
  before_action :find_game, only: %i[show update destroy join pause mark_active mark_inactive]

  # POST /games
  def create
    @game = @user.host_games.create(game_params)
    if @game.valid?
      payload = ActiveModelSerializers::Adapter::Json.new(
        GameSmallSerializer.new(@game)
      ).serializable_hash

      ActionCable.server.broadcast('lobby_channel',
                                   type: 'NEW_GAME',
                                   payload: payload)
      render json: payload, status: :created
    else
      render json: { errors: @game.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # GET /games
  def index
    @games = Game.all # TODO: only return active games with solved < 1?
    render json: @games, each_serializer: GameSmallSerializer
  end

  # GET /games/:id
  def show
    if @game
      @game.set_user_active(@user, true)
      render json: @game
    else
      render json: { message: 'Not found' }, status: :not_found
    end
  end

  # PATCH /games/:id
  def update
    if @game
      @game.update(game_params)
      if @game.valid?
        # TODO: broadcast to game and lobby channels
        render json: @game, status: :ok
      else
        render json: { errors: @game.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { message: 'Not found' }, status: :not_found
    end
  end

  # DELETE /games/:id
  def destroy
    if @game
      @game.destroy
      update_lobby('GAME_REMOVED', {id: params[:id]})
    end
  end

  # PATCH /games/:id/join
  def join
    if @game
      if @game.host != @user
        @game.update(guest: @user)
      end
      if @game.valid?
        payload = ActiveModelSerializers::Adapter::Json.new(
          GameSerializer.new(@game)
        ).serializable_hash

        broadcast_payload(params[:id], 'GAME_JOINED', {
          user: @user,
          puzzle: payload
        })
        render json: @game, status: :ok
      else
        render json: { errors: @game.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { message: 'Not found' }, status: :not_found
    end
  end

  # PATCH /games/:id/update_cell
  def update_cell
    broadcast_payload(params[:id], 'UPDATE_CELL', {
      cell: params[:cell],
      user: @user
    })
  end

  # PATCH /games/:id/update_position
  def update_position
    broadcast_payload(params[:id], 'UPDATE_POSITION', {
      position: params[:position],
      user: @user
    })
  end

  # PATCH /games/:id/check_answer
  def check_answer
    broadcast_payload(params[:id], 'CHECK_ANSWER', {
      cells: params[:cells],
      user: @user
    })
  end

  # PATCH /games/:id/reveal_answer
  def reveal_answer
    broadcast_payload(params[:id], 'REVEAL_ANSWER', {
      cells: params[:cells],
      user: @user
    })
  end

  # PATCH /games/:id/pause
  def pause
    if @game
      @game.update(game_params)
      if @game.valid?
        payload = ActiveModelSerializers::Adapter::Json.new(
          GameSerializer.new(@game)
        ).serializable_hash

        broadcast_payload(params[:id], 'PAUSED', {
          puzzle: payload,
          user: @user
        })
        render json: @game, status: :ok
      else
        render json: { errors: @game.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { message: 'Not found' }, status: :not_found
    end
  end

  # PATCH /games/:id/unpause
  def unpause
    broadcast_payload(params[:id], 'UNPAUSED', {
      user: @user
    })
  end

  # PATCH /games/:id/mark_active
  # def mark_active
  #   if @user == @game.host
  #     @game.update(host_active: true)
  #     broadcast_payload(params[:id], 'HOST_ACTIVE', {
  #       user: @user
  #     })
  #     payload = ActiveModelSerializers::Adapter::Json.new(
  #       GameSmallSerializer.new(@game)
  #     ).serializable_hash
  #     update_lobby('GAME_UPDATED', payload)
  #   elsif @user == @game.guest
  #     @game.update(guest_active: true)
  #     broadcast_payload(params[:id], 'GUEST_ACTIVE', {
  #       user: @user
  #     })
  #     payload = ActiveModelSerializers::Adapter::Json.new(
  #       GameSmallSerializer.new(@game)
  #     ).serializable_hash
  #     update_lobby('GAME_UPDATED', payload)
  #   end
  # end

  # PATCH /games/:id/mark_inactive
  # def mark_inactive
  #   if @user == @game.host
  #     @game.update(host_active: false)
  #     broadcast_payload(params[:id], 'HOST_INACTIVE', {
  #       user: @user
  #     })
  #     payload = ActiveModelSerializers::Adapter::Json.new(
  #       GameSmallSerializer.new(@game)
  #     ).serializable_hash
  #     update_lobby('GAME_UPDATED', payload)
  #   elsif @user == @game.guest
  #     @game.update(guest_active: false)
  #     broadcast_payload(params[:id], 'GUEST_INACTIVE', {
  #       user: @user
  #     })
  #     payload = ActiveModelSerializers::Adapter::Json.new(
  #       GameSmallSerializer.new(@game)
  #     ).serializable_hash
  #     update_lobby('GAME_UPDATED', payload)
  #   end
  # end

  # patch /games/leave_all
  # def leave_all
  #   @user.host_games.where(host_active: true).each do |game|
  #     game.update(host_active: false)
  #     broadcast_payload(game.id, 'HOST_INACTIVE', {
  #       user: @user
  #     })
  #     payload = ActiveModelSerializers::Adapter::Json.new(
  #       GameSmallSerializer.new(game)
  #     ).serializable_hash
  #     update_lobby('GAME_UPDATED', payload)
  #   end
  #   @user.guest_games.where(guest_active: true).each do |game|
  #     game.update(guest_active: false)
  #     broadcast_payload(game.id, 'GUEST_INACTIVE', {
  #       user: @user
  #     })
  #     payload = ActiveModelSerializers::Adapter::Json.new(
  #       GameSmallSerializer.new(game)
  #     ).serializable_hash
  #     update_lobby('GAME_UPDATED', payload)
  #   end
  # end

  private

  def update_lobby(type, payload)
    ActionCable.server.broadcast('lobby_channel',
                                 type: type,
                                 payload: payload)
  end

  def broadcast_payload(id, type, payload)
    game = Game.find_by(id: id)
    GamesChannel.broadcast_to(game, {type: type, payload: payload})
  end

  def find_game
    @game = Game.find_by(id: params[:id])
  end

  def game_params
    params.require(:game).permit(:title, :puzzle, :timer, :solved, :active)
  end
end
