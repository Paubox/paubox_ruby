require 'spec_helper'
require 'mail'
require './spec/helpers/email_disposition_helper'

RSpec.configure do |c|
  c.include Helpers::EmailDispositionHelper
end

RSpec.describe Paubox::EmailDisposition do
  it 'accepts a parsed JSON payload' do
    response = JSON.parse(multi_recipient_delivered)
    disposition = Paubox::EmailDisposition.new(response)
    expect(disposition.response.is_a? Hash).to be true
  end

  it 'returns an array of message deliveries' do
    response = JSON.parse(multi_recipient_delivered)
    disposition = Paubox::EmailDisposition.new(response)
    expect(disposition.message_deliveries.is_a? Array).to be true
    expect(disposition.message_deliveries.empty?).to be false
  end

  it 'returns dates as DateTime objects' do
    response = JSON.parse(single_recipient_delivered)
    disposition = Paubox::EmailDisposition.new(response)
    dates = disposition.message_deliveries.map { |d| [d.status.delivery_time,
                                                      d.status.opened_time] }.flatten
    expect(dates.length.zero?).to be false
    expect(dates.select { |d| !d.is_a? DateTime }.empty?).to be true
  end
end
