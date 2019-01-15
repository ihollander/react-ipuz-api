class Api::V1::PuzzlesController < ApplicationController
  before_action :find_puzzle, only: [:show, :update]

  # POST /puzzles
  def create
    @puzzle = @user.puzzles.find_by(title: params[:puzzle][:title])
    if @puzzle
      @puzzle.update(puzzle_params)
      if @puzzle.valid? 
        render body: nil, status: :no_content
      else
        render json: { errors: @puzzle.errors.full_messages }, status: :unprocessable_entity
      end
    else
      @puzzle = @user.puzzles.create(puzzle_params)
      if @puzzle.valid? 
        render json: @puzzle, status: :created
      else
        render json: { errors: @puzzle.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  # GET /puzzles
  def index
    @puzzles = @user.puzzles
    render json: @puzzles
  end

  # GET /puzzles/:id
  def show
    if @puzzle
      render json: @puzzle
    else
      render json: { message: "Not found" }, status: :not_found 
    end
  end

  # PATCH /puzzles/:id
  def update
    if @puzzle
      @puzzle.update(puzzle_params)
      if @puzzle.valid? 
        render body: nil, status: :no_content
      else
        render json: { errors: @puzzle.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { message: "Not found" }, status: :not_found 
    end
  end

  private

  def find_puzzle
    @puzzle = @user.puzzles.find_by(id: params[:id])
  end

  def puzzle_params
    params.require(:puzzle).permit(:title, :ipuz, :cells, :timer)
  end
end