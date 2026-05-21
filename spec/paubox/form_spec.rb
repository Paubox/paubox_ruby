# frozen_string_literal: true

require 'spec_helper'
require './spec/helpers/form_helper'

RSpec.configure do |c|
  c.include Helpers::FormHelper
end

RSpec.describe Paubox::Form do
  subject(:form) { described_class.new(sample_form_response) }

  describe '#initialize' do
    it 'parses id' do
      expect(form.id).to eq '550e8400-e29b-41d4-a716-446655440000'
    end

    it 'parses title' do
      expect(form.title).to eq 'Patient Intake Form'
    end

    it 'parses description' do
      expect(form.description).to eq 'Please complete before your appointment.'
    end

    it 'parses form_html' do
      expect(form.form_html).to eq '<form>...</form>'
    end

    it 'parses form_json' do
      expect(form.form_json).to eq({})
    end

    it 'parses form_css' do
      expect(form.form_css).to eq 'form { font-family: sans-serif; }'
    end

    it 'parses submission_count' do
      expect(form.submission_count).to eq 42
    end

    it 'parses customer_id' do
      expect(form.customer_id).to eq 123
    end

    it 'parses created_at' do
      expect(form.created_at).to eq '2024-01-15T10:30:00Z'
    end

    it 'parses updated_at' do
      expect(form.updated_at).to eq '2024-06-01T08:00:00Z'
    end

    it 'handles nil optional fields' do
      form = described_class.new({})
      expect(form.title).to be_nil
      expect(form.description).to be_nil
    end
  end

  describe '#active?' do
    it 'returns true when active' do
      expect(form.active?).to be true
    end

    it 'returns false when inactive' do
      expect(described_class.new(sample_form_response.merge('active' => false)).active?).to be false
    end
  end

  describe '#deleted?' do
    it 'returns false when not deleted' do
      expect(form.deleted?).to be false
    end

    it 'returns true when deleted' do
      expect(described_class.new(sample_form_response.merge('deleted' => true)).deleted?).to be true
    end
  end

  describe '#archived?' do
    it 'returns false when not archived' do
      expect(form.archived?).to be false
    end

    it 'returns true when archived' do
      expect(described_class.new(sample_form_response.merge('archived' => true)).archived?).to be true
    end
  end

  describe '#signable?' do
    it 'returns false when not signable' do
      expect(form.signable?).to be false
    end

    it 'returns true when signable' do
      expect(described_class.new(sample_form_response.merge('signable' => true)).signable?).to be true
    end
  end
end
