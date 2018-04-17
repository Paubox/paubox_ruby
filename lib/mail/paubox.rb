module Mail
  class Paubox
    attr_accessor :settings

    def initialize(settings)
      @settings = settings
    end

    def deliver!(mail)
      client = ::Paubox::Client.new(settings)
      client.send_mail(mail)
    end
  end
end

# message = Mail.new do
#   from            'testing@paubox.com'
#   to              'jonathan@paubox.com'
#   subject         'Testing'
#
#   content_type    'text/html; charset=UTF-8'
#   body            '<p>Hello world</p>'
#
#
#   delivery_method Mail::Paubox
# end


# { from: 'me@test.paubox.com', to: 'jonathan@paubox.com', subject: 'Test subject', text_content: 'hello world' }
