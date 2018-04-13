require 'paubox/version'
require 'paubox/client'
require 'paubox/message_builder'
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
