require 'paubox_ruby/version'
require 'paubox_ruby/client'

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
