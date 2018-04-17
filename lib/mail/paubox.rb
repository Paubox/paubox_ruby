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
    attr_accessor :source_tracking_id, :status
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
#
#
# # { from: 'me@test.paubox.com', to: 'jonathan@paubox.com', subject: 'Test subject', text_content: 'hello world' }
#
# Mail.new do
#   from            'testing@paubox.com'
#   to              'jonathan@paubox.com'
#   subject         "Message with attachment at #{Time.zone.now}"
#
#   text_part do
#     body          'Hello world!'
#   end
#
#   html_part do
#     content_type  'text/html; charset=UTF-8'
#     body          '<h1>Hello World!</h1>'
#   end
#
#   add_file         filename: "vi-cheat-sheet.gif", content: File.read("#{Rails.root}/public/vi-cheat-sheet.gif")
#   delivery_method Mail::Paubox
# end