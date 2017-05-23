# tiny, self-contained client

require 'net/http'
require 'json'
require 'curses'

module Infocity
  class Client
    def initialize(host: 'localhost', port: 3000)
      @host = host
      @port = port
    end

    def connect!
      @http = Net::HTTP.new(@host, @port)
    end

    def retrieve_space_details
      get_space_details = Net::HTTP::Get.new("/spaces/1.json")
      response = @http.request(get_space_details)
      JSON.parse(response.body)
    end
  end
end
