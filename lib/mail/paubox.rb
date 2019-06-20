# frozen_string_literal: true

module Mail
  class Paubox
    attr_accessor :settings

    def initialize(settings)
      @settings = settings
    end

    def deliver!(mail)
      client = ::Paubox::Client.new(settings)
      response = client.send_mail(mail)
      puts response
    end
  end

  class Message
    attr_accessor :source_tracking_id, :status, :allow_non_tls, :force_secure_notification
  end
end
