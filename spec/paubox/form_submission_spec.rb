# frozen_string_literal: true

require 'spec_helper'
require './spec/helpers/form_submission_helper'

RSpec.configure do |c|
  c.include Helpers::FormSubmissionHelper
end

RSpec.describe Paubox::FormSubmission do
  describe '#initialize' do
    it 'assigns all attributes from a string-keyed hash' do
      submission = described_class.new(sample_submission_attrs)

      expect(submission.id).to eq Helpers::FormSubmissionHelper::SUBMISSION_ID
      expect(submission.form_id).to eq Helpers::FormSubmissionHelper::SUBMISSION_FORM_ID
      expect(submission.storage_type).to eq 's3'
      expect(submission.storage_url).to eq 'https://storage.example.com/submissions/abc'
      expect(submission.submitter_email).to eq 'jane@example.com'
      expect(submission.recipients).to eq ['intake@clinic.example.com']
      expect(submission.attachment_name).to eq 'consent.pdf'
      expect(submission.attachment_url)
        .to eq 'https://storage.example.com/attachments/consent.pdf'
      expect(submission.attachment_type).to eq 'application/pdf'
      expect(submission.created_at).to eq '2024-06-01T08:00:00Z'
    end

    it 'defaults attributes to nil when args are empty' do
      submission = described_class.new

      expect(submission.id).to be_nil
      expect(submission.form_id).to be_nil
      expect(submission.submitter_email).to be_nil
      expect(submission.created_at).to be_nil
    end
  end

  describe '#form_data' do
    it 'parses a JSON-encoded string into a Hash' do
      attrs = sample_submission_attrs.merge(
        'form_data' => '{"first_name":"Jane","age":30,"consented":true}'
      )

      submission = described_class.new(attrs)

      expect(submission.form_data).to eq('first_name' => 'Jane', 'age' => 30,
                                         'consented' => true)
    end

    it 'parses nested JSON structures' do
      attrs = sample_submission_attrs.merge(
        'form_data' => '{"answers":{"q1":"yes"},"tags":["a","b"]}'
      )

      submission = described_class.new(attrs)

      expect(submission.form_data).to eq('answers' => { 'q1' => 'yes' },
                                         'tags' => %w[a b])
    end

    it 'returns the Hash unchanged when form_data is already a Hash' do
      hash  = { 'first_name' => 'Jane' }
      attrs = sample_submission_attrs.merge('form_data' => hash)

      submission = described_class.new(attrs)

      expect(submission.form_data).to eq hash
    end

    it 'falls back to an empty Hash when the JSON string is malformed' do
      attrs = sample_submission_attrs.merge('form_data' => '{not valid json!')

      submission = described_class.new(attrs)

      expect(submission.form_data).to eq({})
    end

    it 'falls back to an empty Hash when form_data is nil' do
      attrs = sample_submission_attrs.merge('form_data' => nil)

      submission = described_class.new(attrs)

      expect(submission.form_data).to eq({})
    end

    it 'falls back to an empty Hash when form_data is absent' do
      submission = described_class.new({})

      expect(submission.form_data).to eq({})
    end
  end
end
