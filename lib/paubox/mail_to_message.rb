# frozen_string_literal: true

module Paubox
  # The MailToMessage class takes a Ruby Mail object and attempts to parse it
  # into a Hash formatted for the JSON payload of HTTP api request.
  class MailToMessage
    include Paubox::FormatHelper
    attr_reader :mail
    require 'tempfile'

    def initialize(mail, args = {})
      @mail = mail
      @allow_non_tls = args.fetch(:allow_non_tls, false)
      @force_secure_notification = args.fetch(:force_secure_notification, nil)
      @custom_headers = args.fetch(:custom_headers, {})
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
        packaged_attachments << { content: convert_binary_to_base64(attch.body.decoded),
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
        content[:html_content] = base64_encode_if_needed(html_content) unless html_content.nil?
        content[:text_content] = text_content unless text_content.nil?
      elsif mail.content_type.to_s.include? 'text/html'
        content[:html_content] = base64_encode_if_needed(mail.body.to_s)
      else
        content[:text_content] = mail.body.to_s
      end
      content
    end

    def build_headers
      %i[from reply_to subject].map { |k| [k, mail[k].to_s] }.to_h
    end

    def build_force_secure_notification
      if @force_secure_notification.instance_of?(String)
        unless @force_secure_notification.to_s.empty? # if force_secure_notification is not nil or empty
          force_secure_notification_val = @force_secure_notification.strip.downcase
          if force_secure_notification_val == 'true'
            return true
          elsif force_secure_notification_val == 'false'
            return false
          else
            return nil
          end
        end
      end
      nil
    end

    def build_custom_headers
      custom_headers = {}
      @custom_headers.each do |k, v|
        normalized_key = k.to_s.strip.downcase.gsub(/[\s:]+/, '')
        next if normalized_key.empty?
        header_key = /^x-/i =~ normalized_key ? normalized_key : "x-#{normalized_key}"
        custom_headers[header_key] = v
      end
      custom_headers
    end

    def build_parts
      msg = {}
      msg[:recipients] = string_or_array_to_array(mail.to)
      msg[:cc] = string_or_array_to_array(mail.cc)
      msg[:bcc] = string_or_array_to_array(mail.bcc)
      msg[:allow_non_tls] = @allow_non_tls
      @force_secure_notification = build_force_secure_notification
      unless @force_secure_notification.nil?
        msg[:force_secure_notification] = @force_secure_notification
      end
      msg[:headers] = build_headers
      msg[:custom_headers] = build_custom_headers
      msg[:content] = build_content
      msg[:attachments] = build_attachments
      msg
    end

    def convert_binary_to_base64(f)
      file = Tempfile.new(encoding: 'ascii-8bit')
      begin
        file.write(f)
        file.rewind
        Base64.encode64(file.read)
      ensure
        file.close
        file.unlink
      end
    end
  end
end
