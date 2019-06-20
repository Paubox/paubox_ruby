# frozen_string_literal: true

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
    expect(disposition.response.is_a?(Hash)).to be true
  end

  it 'returns an array of message deliveries' do
    response = JSON.parse(multi_recipient_delivered)
    disposition = Paubox::EmailDisposition.new(response)
    expect(disposition.message_deliveries.is_a?(Array)).to be true
    expect(disposition.message_deliveries.empty?).to be false
  end

  it 'returns dates as DateTime objects' do
    response = JSON.parse(single_recipient_delivered)
    disposition = Paubox::EmailDisposition.new(response)
    dates = disposition.message_deliveries.map do |d|
      [d.status.delivery_time,
       d.status.opened_time]
    end .flatten
    expect(dates.length.zero?).to be false
    expect(dates.reject { |d| d.is_a? DateTime }.empty?).to be true
  end

  it 'gets the message_id' do
    response = JSON.parse(single_recipient_delivered)
    disposition = Paubox::EmailDisposition.new(response)
    expect(disposition.message_id.is_a?(String)).to be true
    expect(disposition.message_id.length.zero?).to be false
  end

  it 'gets the source_tracking_id' do
    response = JSON.parse(single_recipient_delivered)
    disposition = Paubox::EmailDisposition.new(response)
    expect(disposition.source_tracking_id.is_a?(String)).to be true
    expect(disposition.source_tracking_id.length.zero?).to be false
  end

  it 'handles error response' do
    response = JSON.parse(error_invalid_access_token)
    disposition = Paubox::EmailDisposition.new(response)
    expect(disposition.errors?).to be true
  end

  it 'returns an array of structs for errors' do
    response = JSON.parse(error_message_not_found)
    disposition = Paubox::EmailDisposition.new(response)
    expect(disposition.errors.is_a?(Array)).to be true
    error = disposition.errors.first
    expect(error.code).to eq 404
    expect(error.title).to eq 'Message was not found'
    expect(error.details).to eq 'Message with this tracking id was not found'
  end
end
