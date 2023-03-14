# frozen_string_literal: true

# Class for Dynamic Templates
class DynamicTemplate < ApplicationRecord
  include DynamicTemplates::Parser

  belongs_to :api_customer
  validates_presence_of :name, :body
end
