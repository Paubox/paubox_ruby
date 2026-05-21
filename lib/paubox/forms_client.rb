# frozen_string_literal: true

module Paubox
  class FormsClient
    require 'rest-client'

    FORMS_HOST     = 'next.paubox.com'
    FORMS_PROTOCOL = 'https://'

    def initialize(args = {})
      @host     = args[:host]     || FORMS_HOST
      @protocol = args[:protocol] || FORMS_PROTOCOL
    end

    def get_form(form_id)
      url      = "#{@protocol}#{@host}/public/form_data/#{form_id}"
      response = RestClient.get(url, accept: :json)
      Paubox::Form.new(JSON.parse(response.body))
    end

    def submit_form(form_id, form_data:, attachments: [])
      url     = "#{@protocol}#{@host}/api/forms/#{form_id}/submissions"
      payload = { form_data: form_data }
      payload[:attachments] = attachments unless attachments.empty?
      RestClient.post(url, payload.to_json, content_type: :json, accept: :json)
    end
  end
end
