# frozen_string_literal: true

module Paubox
  class Form
    attr_reader :id, :title, :description, :form_html, :form_json, :form_css,
                :vanity_url, :version, :active, :customer_id, :signable,
                :signature_confirmation_label, :submission_count, :type,
                :deleted, :archived, :created_at, :updated_at

    def initialize(args = {})
      @id                           = args['id']
      @title                        = args['title']
      @description                  = args['description']
      @form_html                    = args['form_html']
      @form_json                    = args['form_json']
      @form_css                     = args['form_css']
      @vanity_url                   = args['vanity_url']
      @version                      = args['version']
      @active                       = args['active']
      @customer_id                  = args['customer_id']
      @signable                     = args['signable']
      @signature_confirmation_label = args['signature_confirmation_label']
      @submission_count             = args['submission_count']
      @type                         = args['type']
      @deleted                      = args['deleted']
      @archived                     = args['archived']
      @created_at                   = args['created_at']
      @updated_at                   = args['updated_at']
    end

    def active?
      @active
    end

    def deleted?
      @deleted
    end

    def archived?
      @archived
    end

    def signable?
      @signable
    end
  end
end
