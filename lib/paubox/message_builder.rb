module Paubox
  class MessageBuilder
    require 'base64'
    require 'mail'
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
      # msg['attachments'] = build_attachments(mail)
      msg
    end

    def build_attachments
      attachments = mail.attachments
      return [] if attachments.empty?
      packaged_attachments = []
      attachments.each do |attachment|
        a = {}
        case attachment
        when Hash
          a[:content] = attachment[:content]
          a[:filename] = attachment[:filename]
          a[:content_type] = attachment[:content_type]
        when File
          # to do 
        else
          next
        end
        a.map { |k, v| [ruby_to_json_key(k), v] }.to_h
      end
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
      %i(from reply_to subject).map { |k| [ruby_to_json_key(k), mail[k].to_s] }.to_h
      # get_values_whitelist(:from, :reply_to, :subject)
    end

    def get_values_whitelist(*vals)
      vals.map { |k| next unless mail[k]; [ruby_to_json_key(k), mail[k]] }.to_h
    end

    def string_or_array_to_array(object)
      # Allows comma-separated multiple values in string.
      # Also removes whitespace from strings and empty elements from arrays.
      case object
      when String
        a = object.split(',').map { |s| squish(s) }
      when Array
        a = object.map { |s| squish(s) }
      else
        return []
      end
      a.reject { |s| s.empty? }
    end

    def ruby_to_json_key(k)
      { reply_to: 'reply-to', html_body: 'text/html', text_body: 'text/plain',
        filename: 'fileName', content_type: 'contentType' }[k] || k.to_s
    end

    def squish(s)
      s.to_s.split.join(' ')
    end
  end
end
