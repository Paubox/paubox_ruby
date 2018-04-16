module Paubox
  # The MailToMessage class takes a Ruby Mail object and attempts to parse it
  # into a Hash formatted for the JSON payload of HTTP api request.
  class MailToMessage
    include Paubox::FormatHelper
    attr_reader :mail

    def initialize(mail)
      @mail = mail
    end

    def send_message_payload
      { data: { message: convert_keys_to_json_version(build_parts) } }.to_json
    end

    private

    def build_attachments
      attachments = mail.attachments
      return [] if attachments.empty?
      packaged_attachments = []
      attachments.each do |attch|
        packaged_attachments << { content: attch.body.encoded.to_s.chomp,
                                  file_name: attch.filename,
                                  content_type: attch.mime_type }
      end
      packaged_attachments
    end

    def build_content
      content = {}
      if mail.multipart?
        html_content = mail.html_part.body.to_s if mail.html_part
        text_content = mail.text_part.body.to_s if mail.text_part
        content[:html_content] = html_content unless html_content.empty?
        content[:text_content] = text_content unless text_content.empty?
      else
        content[:text_content] = mail.body.to_s
      end
      content
    end

    def build_headers
      %i[from reply_to subject].map { |k| [k, mail[k].to_s] }.to_h
    end

    def build_parts
      msg = {}
      msg[:recipients] = string_or_array_to_array(mail.to)
      msg[:recipients] += string_or_array_to_array(mail.cc)
      msg[:bcc] = string_or_array_to_array(mail.bcc)
      msg[:headers] = build_headers
      msg[:content] = build_content
      msg[:attachments] = build_attachments
      msg
    end
  end
end
