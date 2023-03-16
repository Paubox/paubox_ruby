# frozen_string_literal: true

module Paubox
  class DynamicTemplates
    require 'rest-client'

    def create(template_name, template_file_path)
      path = "dynamic_templates"
      payload = generate_payload(template_name, template_file_path)
      Paubox::Client.new.send_request(method: :post, payload: payload, path: path)
    end

    def update(template_name, template_file_path, template_id)
      path = "dynamic_templates#{template_id}"
      payload = generate_payload(template_name, template_file_path)
      Paubox::Client.new.send_request(method: :patch, payload: payload, path: path)
    end

    def delete(template_id)
      path = "dynamic_templates#{template_id}"
      Paubox::Client.new.send_request(method: :delete, path: path)
    end

    private

    def generate_payload(name, file_path)
      {
        body: File.new(file_path),
        name: name
      }
    end
  end
end
