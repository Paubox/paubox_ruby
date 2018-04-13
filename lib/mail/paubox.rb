module Mail
  class Paubox
    attr_accessor :defaults

    def initialize(defaults)
      @defaults = defaults
    end

    def deliver!(mail)
      client = ::Paubox::Client.new(defaults)
      client.deliver_message(mail)
    end
  end
end
