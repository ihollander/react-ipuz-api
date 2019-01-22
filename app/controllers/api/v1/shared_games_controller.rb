class Api::V1::SharedGamesController < ApplicationController
  before_action :find_puzzle, only: [:create]
  before_action :find_shared_game, only: [:show]

  # POST /puzzles/:puzzle_id/shared_games
  def create
    if @puzzle
      @shared_game = @puzzle.shared_games.create()
     render json: @shared_game, status: :ok
    else
      render json: { message: "Puzzle not found." }, status: :not_found
    end
  end

  # GET /shared_games/:id
  def show
    if @shared_game
      render json: @shared_game
    else
      render json: { message: "Not found" }, status: :not_found 
    end
  end

  # POST /shared_games/:shared_game_id/update_cell
  def update_cell
    cell = params[:cell]
    response = {
      cell: cell,
      user: @user
    }
    game = SharedGame.find_by(id: params[:shared_game_id])
    SharedGamesChannel.broadcast_to(game, {type: 'UPDATE_CELL', payload: response})
  end

  def update_position
    position = params[:position]
    response = {
      position: position,
      user: @user
    }
    game = Game.find_by(id: params[:shared_game_id])
    SharedGamesChannel.broadcast_to(game, {type: 'UPDATE_POSITION', payload: response})
  end

  private

  def find_puzzle
    @puzzle = Puzzle.find_by(id: params[:puzzle_id])
  end
  
  def find_shared_game
    @shared_game = SharedGame.find_by(id: params[:id])
  end
end