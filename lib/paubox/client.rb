module Paubox
  class Client
    require 'rest-client'
    attr_reader :api_key, :api_user, :api_host, :api_version

    def initialize(args = {})
      args = defaults.merge(args)
      @api_key = args[:api_key]
      @api_user = args[:api_user]
      @api_host = args[:api_host]
      @api_version = args[:api_version]
      @test_mode = args[:test_mode]
      @api_base_endpoint = api_base_endpoint
    end

    def api_status
      url = request_endpoint('status')
      RestClient.get(url, accept: :json)
    end

    def deliver_mail(mail)
      payload = { data: { message: MessageBuilder.new(mail).message_payload } }.to_json
      url = request_endpoint('messages')
      RestClient.post(url, payload, accept: :json)
    end

    private

    def api_base_endpoint
      "https://#{api_host}/#{api_version}/#{api_user}"
    end

    def request_endpoint(endpoint)
      "#{api_base_endpoint}/#{endpoint}"
    end

    def defaults
      { api_key: Paubox.configuration.api_key,
        api_user: Paubox.configuration.api_user,
        api_host: 'api.paubox.net',
        api_version: 'v1',
        test_mode: false }
    end
  end
end
