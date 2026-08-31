# frozen_string_literal: true

module Paubox
  # Client sends API requests to Paubox API
  class Client
    require 'rest-client'
    attr_reader :api_key, :api_host, :api_protocol, :api_version

    # Deprecated: api_user is no longer used for authentication or URLs.
    # It is kept only for backward compatibility and has no effect on requests.
    attr_reader :api_user

    def initialize(args = {})
      args = defaults.merge(args)
      @api_key = args[:api_key]
      @api_user = args[:api_user] # deprecated no-op, kept for backward compatibility
      @api_host = args[:api_host]
      @api_protocol = args[:api_protocol]
      @api_version = args[:api_version]
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
      when Paubox::Message, Paubox::TemplatedMessage
        payload = mail.send_message_payload
      end
      url = request_endpoint(mail.is_a?(Paubox::TemplatedMessage) ? 'templated_messages' : 'messages')
      response = RestClient.post(url, payload, auth_header)
      if mail.class == Mail::Message
        mail.source_tracking_id = JSON.parse(response.body)['sourceTrackingId']
      end
      JSON.parse(response.body)
    end
    alias deliver_mail send_mail

    def email_disposition(source_tracking_id)
      url = "#{request_endpoint('message_receipt')}?sourceTrackingId=#{source_tracking_id}"
      response = RestClient.get(url, auth_header)
      Paubox::EmailDisposition.new(JSON.parse(response.body))
    end
    alias message_receipt email_disposition

    def send_request(method: :get, payload: {}, path: '')
      url = request_endpoint(path)

      RestClient::Request.execute(method: method, url: url, payload: payload, headers: auth_header)
    end

    private

    def auth_header
      { accept: :json,
        content_type: :json,
        Authorization: "Token token=#{@api_key}" }
    end

    def api_base_endpoint
      "#{api_protocol}#{api_host}/#{api_version}/email"
    end

    def request_endpoint(endpoint)
      "#{api_base_endpoint}/#{endpoint}"
    end

    def defaults
      { api_key: Paubox.configuration.api_key,
        api_user: Paubox.configuration.api_user, # deprecated, unused
        api_host: 'api.paubox.com',
        api_protocol: 'https://',
        api_version: 'v1' }
    end
  end
end
