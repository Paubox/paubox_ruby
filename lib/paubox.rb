require 'paubox/version'
require 'paubox/client'
require 'paubox/format_helper'
require 'paubox/mail_to_message'
require 'paubox/message'
require 'mail/paubox'

module Paubox
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :api_key, :api_user
  end
end
