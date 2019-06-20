# frozen_string_literal: true

module Paubox
  # The Message class is for building a Paubox email message using a hash.
  class Message
    include Paubox::FormatHelper
    attr_accessor :from, :to, :cc, :bcc, :subject, :reply_to, :text_content,
                  :html_content, :allow_non_tls, :force_secure_notification

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
      @allow_non_tls = args.fetch(:allow_non_tls, false)
      @force_secure_notification = args.fetch(:force_secure_notification, nil)
    end

    def send_message_payload
      { data: { message: convert_keys_to_json_version(build_parts) } }.to_json
    end

    def add_attachment(file_path)
      @packaged_attachments << { filename: file_path.split('/').last,
                                 content_type: `file --b --mime-type #{file_path}`.chomp,
                                 content: Base64.encode64(File.read(file_path)) }
    end

    def attachments
      @packaged_attachments
    end

    def attachments=(args)
      @attachments = build_attachments(args)
    end

    private

    def build_attachments(args)
      return (@packaged_attachments = []) if args.to_a.empty?

      args.each do |a|
        a[:content] = base64_encode_if_needed(a[:content])
        @packaged_attachments << a
      end
      @packaged_attachments
    end

    def build_content
      content = {}
      content[:text_content] = text_content if text_content
      content[:html_content] = base64_encode_if_needed(html_content) if html_content
      content
    end

    def build_headers
      %i[from reply_to subject].map { |k| [k, send(k)] }.to_h
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

    def build_parts
      msg = {}
      msg[:recipients] = string_or_array_to_array(to)
      msg[:cc] = string_or_array_to_array(cc)
      msg[:allow_non_tls] = @allow_non_tls
      @force_secure_notification = build_force_secure_notification
      unless @force_secure_notification.nil?
        msg[:force_secure_notification] = @force_secure_notification
      end
      msg[:bcc] = string_or_array_to_array(bcc)
      msg[:headers] = build_headers
      msg[:content] = build_content
      msg[:attachments] = attachments
      msg
    end
  end
end
