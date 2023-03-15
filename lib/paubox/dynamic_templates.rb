# frozen_string_literal: true

module Paubox
  # Client sends API requests to Paubox API
  class DynamicTemplates
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

    def create(template_name, template_file_path)
      payload = {
        body: File.new(template_file_path),
        name: template_name 
      }
      url = request_endpoint('dynamic_templates')
      response = RestClient.post(url, payload, auth_header)
    end

    def update(template_name, template_file_path, template_id)
      payload = {
        body: File.new(template_file_path),
        name: template_name 
      }
      url = request_endpoint("dynamic_templates/#{template_id}")
      response = RestClient.patch(url, payload, auth_header)
    end

    def destroy(template_id)
      url = request_endpoint("dynamic_templates/#{template_id}")
      response = RestClient.delete(url, auth_header)
    end

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
