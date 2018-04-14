module Paubox
  class Message
    require 'base64'

    attr_accessor :from, :to, :cc, :bcc, :subject, :reply_to, :text_content,
                  :html_content

    def initialize(args)
      @from = args[:from]
      @to = args[:to]
      @cc = args[:cc]
      @bcc = args[:bcc]
      @subject = args[:subject]
      @reply_to = args[:reply_to]
      @text_content = args[:text_content]
      @html_content = args[:html_content]
      @packaged_attachments = []
      @attachments = build_attachments(args[:attachments])
    end

    def add_attachment(file_path)
      @packaged_attachments << { filename: file_path.split('/').last,
        content_type: `file --b --mime-type #{file_path}`.chomp,
        content: Base64.encode64(File.read(file_path)) }
    end

    def attachments=(args)
      @attachments = build_attachments(args)
    end

    def attachments
      @packaged_attachments
    end

    def send_message_payload
      { data: { message: build_parts } }.to_json
    end

    def build_attachments(args)
      return @packaged_attachments = [] if args.to_a.empty?
      args.each do |a|
        a[:content] =  base64_encode_if_needed(a[:content])
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

    def build_parts
      msg = {}
      msg['recipients'] = string_or_array_to_array(to) + string_or_array_to_array(cc)
      msg['bcc'] = string_or_array_to_array(bcc)
      msg['headers'] = build_headers
      msg['content'] = build_content
      msg['attachments'] = build_attachments
      msg
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

    # def ruby_to_json_key(key)
    #   { reply_to: 'reply-to', html_body: 'text/html', text_body: 'text/plain',
    #     filename: 'fileName', content_type: 'contentType' }[key] || key.to_s
    # end

    def base64_encode_if_needed(str)
      return str if base64_encoded?(str.to_s)
      Base64.encode64(str.to_s)
    end

    def base64_encoded?(str)
      encoded = Base64.encode64(str)
      encoded == Base64.encode64(Base64.decode64(encoded))
    end

    def squish(str)
      str.to_s.split.join(' ')
    end
  end
end