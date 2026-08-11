# frozen_string_literal: true

module Paubox
  class FormSubmission
    attr_reader :id, :form_id, :form_data, :storage_type, :storage_url,
                :submitter_email, :recipients, :attachment_name,
                :attachment_url, :attachment_type, :created_at

    def initialize(args = {})
      @id              = args['id']
      @form_id         = args['form_id']
      @form_data       = parse_form_data(args['form_data'])
      @storage_type    = args['storage_type']
      @storage_url     = args['storage_url']
      @submitter_email = args['submitter_email']
      @recipients      = args['recipients']
      @attachment_name = args['attachment_name']
      @attachment_url  = args['attachment_url']
      @attachment_type = args['attachment_type']
      @created_at      = args['created_at']
    end

    private

    def parse_form_data(form_data)
      return {} if form_data.nil?
      return form_data if form_data.is_a?(Hash)

      JSON.parse(form_data)
    rescue JSON::ParserError
      {}
    end
  end
end
