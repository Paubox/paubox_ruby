# frozen_string_literal: true

require 'paubox/version'
require 'paubox/client'
require 'paubox/format_helper'
require 'paubox/mail_to_message'
require 'paubox/message'
require 'paubox/email_disposition'
require 'mail/paubox'

module Paubox
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  def self.reset_configuration!
    self.configuration = Configuration.new
  end

  class Configuration
    attr_accessor :api_key, :api_user
  end
end
