module HerbachAPI
  class ApiClient
    API_URL = "http://herbach.dnsalias.com"

    def self.get_wsj(filename)
      self.request(
        http_method: :get,
        endpoint: "/wsj/#{filename}"
      )
    end

    def self.get_wapo(filename)
      self.request(
        http_method: :get,
        endpoint: "/WaPo/#{filename}"
      )
    end

    def self.get_ps(filename)
      self.request(
        http_method: :get,
        endpoint: "/ps/#{filename}"
      )
    end

    private

    def self.client
      Faraday.new(API_URL) do |client|
        client.request :url_encoded
        client.adapter Faraday.default_adapter
      end
    end

    def self.request(http_method:, endpoint:)
      self.client.public_send(http_method, endpoint)
    end

  end
end