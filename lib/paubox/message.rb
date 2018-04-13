module Paubox
  class Message
    require 'base64'
    require 'file'

    attr_accessor :from, :to, :cc, :bcc, :subject, :reply_to, :text_content,
                  :html_content, :attachments

    def initialize(args)
      @from = args[:from]
      @to = args[:to]
      @cc = args[:cc]
      @bcc = args[:bcc]
      @subject = args[:subject]
      @reply_to = args[:reply_to]
      @text_content = args[:text_content]
      @html_content = args[:html_content]
      @attachments = args[:attachments]
      @packaged_attachments = []
    end

    def send_message_payload
      { data: { message: build_parts } }.to_json
    end

    def build_parts
      msg = {}
      msg['recipients'] = string_or_array_to_array(to) + string_or_array_to_array(cc)
      msg['bcc'] = string_or_array_to_array(bcc)
      msg['headers'] = build_headers
      msg['content'] = build_content
      msg['attachments'] = build_attachments
      msg
    end

    def build_attachments
      return [] if attachments.empty?
      attachments.each do |a| 
        a[:content] =  Base64.encode64(a[:content].to_s).chomp
        @packaged_attachments << a
      end
      @packaged_attachments
    end

    def build_content
      content = {}
      content[:text_content] = text_content if text_content
      content[:html_content] = html_content if html_content
      content
    end

    def build_headers
      %i[from reply_to subject].map { |key| [key, self.send(key)] }
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