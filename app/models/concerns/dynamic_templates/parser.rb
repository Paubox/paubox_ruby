# frozen_string_literal: true

require 'ruby-handlebars'

module DynamicTemplates
  # Include in dynamic_template model to allow template parsing features
  module Parser
    extend ActiveSupport::Concern

    # Compiles the template to html with the provided args
    #
    # @param args [Hash] a hash of keyword args
    # @return [HTML] The compiled HTML template
    def compile(args)
      html = compile_html(args)
      {
        'text/html' => html,
        'text/plain' => compile_plain(html)
      }
    end

    # Compiles the template to html with the provided args
    #
    # @param args [Hash] a hash of keyword args
    # @return [HTML] The compiled HTML template
    def compile_html(args)
      hb_object = Handlebars::Handlebars.new
      hb_object.compile(body).call(args)
    end

    # Compiles the template to plain text with the provided args
    #
    # @param html [String] Compiled HTML input
    # @return [String] The compiled String template
    def compile_plain(html)
      doc = Nokogiri::HTML.parse(html)
      doc.text
    end
  end
end
