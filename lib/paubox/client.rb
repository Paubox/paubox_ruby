# frozen_string_literal: true

module Paubox
  # Client sends API requests to Paubox API
  class Client
    require 'rest-client'
    require 'ostruct'
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
      when Mail::Message
        allow_non_tls = mail.allow_non_tls.nil? ? false : mail.allow_non_tls
        payload = MailToMessage.new(mail, allow_non_tls: allow_non_tls)
                               .send_message_payload
      when Hash
        payload = Message.new(mail).send_message_payload
      when Paubox::Message
        payload = mail.send_message_payload
      end
      url = request_endpoint('messages')
      response = RestClient.post(url, payload, auth_header)
      if mail.class == Mail::Message
        mail.source_tracking_id = JSON.parse(response.body)['sourceTrackingId']
      end
      JSON.parse(response.body)['sourceTrackingId']
    end
    alias deliver_mail send_mail

    def email_disposition(source_tracking_id)
      url = "#{request_endpoint('message_receipt')}?sourceTrackingId=#{source_tracking_id}"
      response = RestClient.get(url, auth_header)
      email_disposition = Paubox::EmailDisposition.new(JSON.parse(response.body))
    end
    alias message_receipt email_disposition

    private

    def auth_header
      { accept: :json,
        content_type: :json,
        Authorization: "Token token=#{@api_key}" }
    end

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

    # recursively converts a nested Hash into OpenStruct
    def to_open_struct(hash)
      OpenStruct.new(hash.each_with_object({}) do |(key, val), memo|
        memo[key] = val.is_a?(Hash) ? to_open_struct(val) : val
      end)
    end
  end
end
