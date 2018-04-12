module Paubox
  class MessageBuilder
    attr_reader :args

    def initialize(args)
      @args = args
    end

    def render_message_payload
      msg = {}
      msg['recipients'] = string_or_array_to_array(args[:to])
      msg['recipients'] += string_or_array_to_array(args[:cc]) if args[:cc]
      msg['bcc'] = string_or_array_to_array(args[:bcc])
      msg['headers'] = build_headers(args)
      msg['content'] = build_content(args)
      msg['attachments'] = build_attachments(args)
      msg
    end

    def build_attachments
      
    end

    def build_content
      content = {}
      content['text/html'] = args[:html_body] if args['html_body']
      content['text/plain'] = args[:text_body] if args['text_body']
      content
    end

    def build_headers
      get_values_whitelist(:from, :reply_to, :subject)
    end

    def get_values_whitelist(*vals)
      # binding.pry
      vals.map { |k| next unless args[k]; [ruby_to_json_key(k), args[k]] }.to_h
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
      { reply_to: 'reply-to',
        html_body: 'text/html',
        text_body: 'text/plain' }[k] || k.to_s
    end

    def squish(s)
      s.to_s.split.join(' ')
    end
  end
end
