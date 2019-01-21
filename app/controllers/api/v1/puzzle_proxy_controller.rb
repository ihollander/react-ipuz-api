class Api::V1::PuzzleProxyController < ApplicationController
  skip_before_action :authorized

  def today
    date = DateTime.now.strftime("%y%m%d")
    filename = "wsj#{date}.puz"
    response = HerbachAPI::ApiClient.get_wsj(filename)
    if response.success?
      send_data response.body, filename: filename, type: 'application/x-crossword'
    else
      filename = "wp#{date}.puz"
      response = HerbachAPI::ApiClient.get_wapo(filename)
      if response.success?
        send_data response.body, filename: filename, type: 'application/x-crossword'
      else
        render json: { message: "Puzzle not found" }, status: response.status
      end
    end
  end

  # MON-SAT
  def wsj
    date = params[:date]
    filename = "wsj#{date}.puz"
    response = HerbachAPI::ApiClient.get_wsj(filename)
    if response.success?
      send_data response.body, filename: filename, type: 'application/x-crossword'
    else
      render json: { message: "Puzzle not found" }, status: response.status
    end
  end

  # SUN
  def wapo
    date = params[:date]
    filename = "wp#{date}.puz"
    response = HerbachAPI::ApiClient.get_wapo(filename)
    if response.success?
      send_data response.body, filename: filename, type: 'application/x-crossword'
    else
      render json: { message: "Puzzle not found" }, status: response.status
    end
  end

  def ps
    date = params[:date]
    filename = "ps#{date}.puz"
    response = HerbachAPI::ApiClient.get_ps(filename)
    if response.success?
      send_data response.body, filename: filename, type: 'application/x-crossword'
    else
      render json: { message: "Puzzle not found" }, status: response.status
    end
  end

  # THU
  def jonesin
    date = params[:date]
    filename = "jz#{date}.puz"
    response = HerbachAPI::ApiClient.get_ps(filename)
    if response.success?
      send_data response.body, filename: filename, type: 'application/x-crossword'
    else
      render json: { message: "Puzzle not found" }, status: response.status
    end
  end
end
