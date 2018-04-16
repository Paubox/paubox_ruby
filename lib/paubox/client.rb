module Paubox
  # Client sends API requests to Paubox API
  class Client
    require 'rest-client'
    attr_reader :api_key, :api_user, :api_host, :api_protocol, :api_version

    def initialize(args = {})
      args = defaults.merge(args)
      @api_key = args[:api_key]
      @api_user = args[:api_user]
      @api_host = args[:api_host]
      @api_protocol = args[:api_protocol]
      @api_version = args[:api_version]
      @test_mode = args[:test_mode]
      @api_base_endpoint = api_base_endpoint
    end

    def api_status
      url = request_endpoint('status')
      RestClient.get(url, accept: :json)
    end

    def send_mail(mail)
      case mail
      when Mail
        payload = MailToMessage.new(mail).send_message_payload
      when Hash
        payload = Message.new(mail).send_message_payload
      end
      url = request_endpoint('messages')
      RestClient.post(url, payload, accept: :json)
    end
    alias deliver_mail send_mail

    private

    def api_base_endpoint
      "#{api_protocol}#{api_host}/#{api_version}/#{api_user}"
    end

    def request_endpoint(endpoint)
      "#{api_base_endpoint}/#{endpoint}"
    end

    def defaults
      { api_key: Paubox.configuration.api_key,
        api_user: Paubox.configuration.api_user,
        api_host: 'api.paubox.net',
        api_protocol: 'https://',
        api_version: 'v1',
        test_mode: false }
    end
  end
end
