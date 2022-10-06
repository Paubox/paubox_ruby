# frozen_string_literal: true

require 'spec_helper'
require './spec/helpers/message_helper'
require 'tempfile'

RSpec.configure do |c|
  c.include Helpers::MessageHelper
end

RSpec.describe Paubox::TemplatedMessage do
  it 'assembles the payload correctly' do
    message = Paubox::TemplatedMessage.new(message_with_template_args)

    parsed_payload = JSON.parse(message.send_message_payload)

    expect(parsed_payload).to have_key('data')
    expect(parsed_payload['data']).to have_key('template_name')
    expect(parsed_payload['data']).to have_key('template_values')
  end
end
