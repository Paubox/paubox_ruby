require "spec_helper"

RSpec.describe Paubox::MessageBuilder do
  describe '#build_headers' do
    it 'returns a hash of headers' do
      args = { from: 'tester@test.com', reply_to: 'reply-to@test.com', subject: 'test subject' }
      builder = Paubox::MessageBuilder.new(args)
      headers = builder.send(:build_headers)
      expect(args.values).to eq headers.values
    end
  end
end