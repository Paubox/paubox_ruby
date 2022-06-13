# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Paubox do
  it 'has a version number' do
    expect(Paubox::VERSION).not_to be nil
  end

  describe 'unconfigured client has empty API key and user' do
    it 'Does not set API user' do
      Paubox.reset_configuration!
      client = Paubox::Client.new
      expect(client.api_user).to eq('')
    end

    it 'Does not set API key' do
      Paubox.reset_configuration!
      client = Paubox::Client.new
      expect(client.api_key).to eq('')
    end
  end

  describe '#configure' do
    it 'Sets the API key' do
      Paubox.configure do |config|
        config.api_key = 'test_key'
        config.api_user = 'test_user'
      end
      client = Paubox::Client.new
      expect(client.api_key).to eq 'test_key'
    end

    it 'Sets the API user' do
      Paubox.configure do |config|
        config.api_key = 'test_key'
        config.api_user = 'test_user'
      end
      client = Paubox::Client.new
      expect(client.api_user).to eq 'test_user'
    end
  end
end
