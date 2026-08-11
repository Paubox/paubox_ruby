# frozen_string_literal: true

module Helpers
  module FormSubmissionHelper
    SUBMISSION_FORM_ID = '550e8400-e29b-41d4-a716-446655440000'
    SUBMISSION_ID      = '7c9e6679-7425-40de-944b-e07fc1f90ae7'
    API_KEY            = 'test-forms-scoped-key'

    def sample_submission_attrs
      {
        'id'              => SUBMISSION_ID,
        'form_id'         => SUBMISSION_FORM_ID,
        'form_data'       => '{"first_name":"Jane","last_name":"Smith"}',
        'storage_type'    => 's3',
        'storage_url'     => 'https://storage.example.com/submissions/abc',
        'submitter_email' => 'jane@example.com',
        'recipients'      => ['intake@clinic.example.com'],
        'attachment_name' => 'consent.pdf',
        'attachment_url'  => 'https://storage.example.com/attachments/consent.pdf',
        'attachment_type' => 'application/pdf',
        'created_at'      => '2024-06-01T08:00:00Z'
      }
    end

    def sample_list_submissions_response
      {
        'data'  => [sample_submission_attrs,
                    sample_submission_attrs.merge(
                      'id'              => 'a1b2c3d4-0000-1111-2222-333344445555',
                      'form_data'       => '{"first_name":"John"}',
                      'submitter_email' => 'john@example.com'
                    )],
        'total' => 2,
        'page'  => 1,
        'items' => 25
      }
    end

    def sample_csv_body
      "id,submitter_email,created_at\n" \
        "#{SUBMISSION_ID},jane@example.com,2024-06-01T08:00:00Z\n"
    end

    def sample_pdf_body
      "%PDF-1.4\n1 0 obj\n<< /Type /Catalog >>\nendobj\n%%EOF"
    end
  end
end
