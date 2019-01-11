class Api::V1::PuzzleProxyController < ApplicationController
  def wsj
    date = params[:date]
    file_name = "wsj#{date}.puz"
    f_client = Faraday.new('http://herbach.dnsalias.com') do |client|
      client.request :url_encoded
      client.adapter Faraday.default_adapter
    end
    response = f_client.public_send(:get, "/wsj/#{file_name}")
    if response.success?
      send_data response.body, filename: file_name, type: 'application/x-crossword'
    else
      render json: { message: "Error loading puzzle" }, status: response.status
    end
  end

  def wapo
    date = params[:date]
    file_name = "wp#{date}.puz"
    f_client = Faraday.new('http://herbach.dnsalias.com') do |client|
      client.request :url_encoded
      client.adapter Faraday.default_adapter
    end
    response = f_client.public_send(:get, "/WaPo/#{file_name}")
    if response.success?
      send_data response.body, filename: file_name, type: 'application/x-crossword'
    else
      render json: { message: "Error loading puzzle" }, status: response.status
    end
  end
end
