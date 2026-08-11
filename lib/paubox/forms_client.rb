# frozen_string_literal: true

module Paubox
  class FormsClient
    require 'rest-client'

    FORMS_HOST     = 'apx.paubox.com'
    FORMS_PROTOCOL = 'https://'
    FORMS_BASE     = '/forms'

    LIST_FORMS_PARAMS = %i[customer_id form_id search order order_by
                           archived active page items].freeze
    LIST_SUBMISSIONS_PARAMS = %i[submission_id order_by order page items].freeze

    def initialize(args = {})
      @host     = args[:host]     || FORMS_HOST
      @protocol = args[:protocol] || FORMS_PROTOCOL
      @base     = args[:base]     || FORMS_BASE
      @api_key  = args[:api_key]  ||
                  (Paubox.configuration && Paubox.configuration.forms_api_key)
    end

    def get_form(form_id)
      url      = "#{@protocol}#{@host}#{@base}/public/form_data/#{form_id}"
      response = RestClient.get(url, accept: :json)
      Paubox::Form.new(JSON.parse(response.body))
    end

    def submit_form(form_id, form_data:, attachments: [])
      url     = "#{@protocol}#{@host}#{@base}/api/forms/#{form_id}/submissions"
      payload = { form_data: form_data }
      payload[:attachments] = attachments unless attachments.empty?
      RestClient.post(url, payload.to_json, content_type: :json, accept: :json)
    end

    def list_forms(params = {})
      url   = "#{@protocol}#{@host}#{@base}/api/forms"
      query = params.transform_keys(&:to_sym)
                    .select { |k, _v| LIST_FORMS_PARAMS.include?(k) }
      if query[:customer_id].nil?
        raise ArgumentError, 'customer_id is required for list_forms and must ' \
                             "match the API key's customer, e.g. " \
                             'client.list_forms(customer_id: 123)'
      end

      response = RestClient.get(url, auth_headers.merge(params: query))
      body     = JSON.parse(response.body)
      forms    = (body['results'] || []).map { |form| Paubox::Form.new(form) }
      { forms: forms, page_info: body['page_info'] }
    end

    def create_form(attrs)
      url      = "#{@protocol}#{@host}#{@base}/api/forms"
      response = RestClient.post(url, attrs.to_json,
                                 auth_headers.merge(content_type: :json))
      JSON.parse(response.body)
    end

    def find_form(form_id)
      url      = "#{@protocol}#{@host}#{@base}/api/forms/#{form_id}"
      response = RestClient.get(url, auth_headers)
      Paubox::Form.new(JSON.parse(response.body)['data'])
    end

    def update_form(form_id, attrs)
      url      = "#{@protocol}#{@host}#{@base}/api/forms/#{form_id}"
      response = RestClient.put(url, attrs.to_json,
                                auth_headers.merge(content_type: :json))
      JSON.parse(response.body)
    end

    def archive_form(form_id)
      url      = "#{@protocol}#{@host}#{@base}/api/forms/#{form_id}/archive"
      response = RestClient.post(url, '{}', auth_headers.merge(content_type: :json))
      JSON.parse(response.body)
    end

    def unarchive_form(form_id)
      url      = "#{@protocol}#{@host}#{@base}/api/forms/#{form_id}/unarchive"
      response = RestClient.post(url, '{}', auth_headers.merge(content_type: :json))
      JSON.parse(response.body)
    end

    def copy_form(form_id, title:)
      url      = "#{@protocol}#{@host}#{@base}/api/forms/copy"
      payload  = { form_id: form_id, title: title }
      response = RestClient.post(url, payload.to_json,
                                 auth_headers.merge(content_type: :json))
      Paubox::Form.new(JSON.parse(response.body))
    end

    def form_stats(customer_id: nil)
      url     = "#{@protocol}#{@host}#{@base}/api/forms/stats"
      headers = auth_headers
      headers = headers.merge(params: { customer_id: customer_id }) unless customer_id.nil?
      response = RestClient.get(url, headers)
      JSON.parse(response.body)
    end

    def list_submissions(form_id, params = {})
      url      = "#{@protocol}#{@host}#{@base}/api/forms/#{form_id}/submissions"
      query    = params.transform_keys(&:to_sym)
                       .select { |k, _v| LIST_SUBMISSIONS_PARAMS.include?(k) }
      response = RestClient.get(url, auth_headers.merge(params: query))
      body     = JSON.parse(response.body)
      submissions = (body['data'] || []).map { |s| Paubox::FormSubmission.new(s) }
      { submissions: submissions, total: body['total'], page: body['page'],
        items: body['items'] }
    end

    def submissions_csv(form_id, submission_id: nil)
      url = "#{@protocol}#{@host}#{@base}/api/forms/#{form_id}/submissions/submission-csv"
      url = "#{url}/#{submission_id}" unless submission_id.nil?
      RestClient.get(url, auth_headers(accept: 'text/csv')).body
    end

    def submission_pdf(form_id, submission_id)
      url = "#{@protocol}#{@host}#{@base}/api/forms/#{form_id}/submissions/" \
            "#{submission_id}/submission-pdf"
      RestClient.get(url, auth_headers(accept: 'application/pdf')).body
    end

    private

    def auth_headers(accept: :json)
      if @api_key.nil? || @api_key.to_s.empty?
        raise ArgumentError, "api_key is required for this endpoint. Pass a scoped " \
                             "API key with the 'forms' scope: " \
                             'Paubox::FormsClient.new(api_key: ...)'
      end

      { authorization: "Bearer #{@api_key}", accept: accept }
    end
  end
end
