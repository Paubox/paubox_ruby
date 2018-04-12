module Mail
  class Paubox
    attr_accessor :settings

    def initialize(settings)
      @settings = settings
    end

    def deliver!(mail)
      client = ::Paubox::Client.new(settings)
      client.deliver_message(mail)
    end
  end
end