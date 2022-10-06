# frozen_string_literal: true

module Paubox
  # The TemplatedMessage class is for building a Paubox email message from a dynamic template, using a hash.
  class TemplatedMessage < Message
    attr_accessor :template_name,
                  :template_values
                  
    def initialize(args)
      @template_name = args[:template][:name]
      @template_values = args[:template][:values]

      super
    end

    def send_message_payload
      # template name and values must be outside the `message` object
      msg = convert_keys_to_json_version(build_parts)

      template_params = {
        template_name: @template_name,
        template_values: @template_values.to_json
      }

      { data: { message: convert_keys_to_json_version(build_parts) }.merge(template_params) }.to_json
    end
  end
end
