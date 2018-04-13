module Paubox
  # The MessageBuilder class takes a Ruby Mail object and attempts to parse it
  # into a Hash formatted for the JSON payload of HTTP api request.
  class MessageBuilder
    attr_reader :mail

    def initialize(mail)
      @mail = mail
    end

    def message_payload
      msg = {}
      msg['recipients'] = string_or_array_to_array(mail.to)
      msg['recipients'] += string_or_array_to_array(mail.cc)
      msg['bcc'] = string_or_array_to_array(mail.bcc)
      msg['headers'] = build_headers
      msg['content'] = build_content
      msg['attachments'] = build_attachments
      msg
    end

    def build_attachments
      attachments = mail.attachments
      return [] if attachments.empty?
      packaged_attachments = []
      attachments.each do |attch|
        packaged_attachments << { 'content' => attch.body.encoded.to_s.chomp,
                                  'fileName' => attch.filename,
                                  'contentType' => attch.mime_type }
      end
      packaged_attachments
    end

    def build_content
      content = {}
      if mail.multipart?
        html_content = mail.html_part.body.to_s if mail.html_part
        text_content = mail.text_part.body.to_s if mail.text_part
        content['text/html'] = html_content unless html_content.empty?
        content['text/plain'] = text_content unless text_content.empty?
      else
        content['text/plain'] = mail.body.to_s
      end
      content
    end

    def build_headers
      %i[from reply_to subject].map { |key| [ruby_to_json_key(key), mail[key].to_s] }
                               .to_h
    end

    def get_values_whitelist(*vals)
      vals.map { |k| next unless mail[k]; [ruby_to_json_key(k), mail[k]] }.to_h
    end

    def string_or_array_to_array(object)
      case object
      when String
        a = object.split(',').map { |str| squish(str) }
      when Array
        a = object.map { |s| squish(s) }
      else
        return []
      end
      a.reject(&:empty?)
    end

    def ruby_to_json_key(key)
      { reply_to: 'reply-to', html_body: 'text/html', text_body: 'text/plain',
        filename: 'fileName', content_type: 'contentType' }[key] || key.to_s
    end

    def squish(str)
      str.to_s.split.join(' ')
    end
  end
end
