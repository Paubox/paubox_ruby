# frozen_string_literal: true

module Paubox
  class Webhook

    attr_accessor :id, :target_url, :signing_key, :api_key, :active, :events
    
    def initialize(args = {})
      @id = args['id']
      @target_url = args['target_url']
      @signing_key = args['signing_key']
      @api_key = args['api_key']
      @active = args['active']
      @events = args['events']
    end

    def update(target_url: nil, signing_key: nil, api_key: nil, active: nil, events: nil)
      path = "webhook_endpoints/#{id}"
      payload = {
          target_url: target_url,
          signing_key: signing_key,
          api_key: api_key,
          active: active,
          events: events
        }

      Paubox::Client.new.send_request(method: :patch, payload: payload, path: path)
    end

    def delete
      path = "webhook_endpoints/#{id}"
      Paubox::Client.new.send_request(method: :delete, path: path)
    end

    class << self
      def create(target_url: nil, signing_key: nil, api_key: nil, active: nil, events: nil)
        path = "webhook_endpoints"
        payload = {
          target_url: target_url,
          signing_key: signing_key,
          api_key: api_key,
          active: active,
          events: events
        }
        
        Paubox::Client.new.send_request(method: :post, payload: payload, path: path)
      end

      def find(id)
        path = "webhook_endpoints/#{id}"
        response = Paubox::Client.new.send_request(method: :get, path: path)
        data = JSON.parse(response.body)
        Paubox::Webhook.new(data)
      end

      def list
        path = "webhook_endpoints"
        response = Paubox::Client.new.send_request(method: :get, path: path)
        response
      end
    end
  end
end
