# frozen_string_literal: true

module Helpers
  module FormHelper
    FORM_ID = '550e8400-e29b-41d4-a716-446655440000'

    def sample_form_response
      {
        'id'                           => FORM_ID,
        'title'                        => 'Patient Intake Form',
        'description'                  => 'Please complete before your appointment.',
        'form_json'                    => {},
        'form_html'                    => '<form>...</form>',
        'form_css'                     => 'form { font-family: sans-serif; }',
        'vanity_url'                   => nil,
        'version'                      => 1,
        'active'                       => true,
        'customer_id'                  => 123,
        'signable'                     => false,
        'signature_confirmation_label' => nil,
        'submission_count'             => 42,
        'type'                         => nil,
        'deleted'                      => false,
        'archived'                     => false,
        'created_at'                   => '2024-01-15T10:30:00Z',
        'updated_at'                   => '2024-06-01T08:00:00Z'
      }
    end

    def sample_form_data
      { first_name: 'Jane', last_name: 'Smith', email: 'jane@example.com' }
    end

    def sample_attachments
      [{ name: 'consent.pdf', content: 'JVBERi0xLjQ...' }]
    end

    def sample_paged_forms_response
      {
        'results'   => [
          sample_form_response,
          sample_form_response.merge('id'    => 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
                                     'title' => 'Consent Form')
        ],
        'page_info' => { 'count' => 2, 'pages' => 1, 'page' => 1, 'items' => 25 }
      }
    end

    def sample_form_stats
      {
        'active_form_count'       => 5,
        'total_submission_count'  => 120,
        'submissions_last_7_days' => 7
      }
    end

    def sample_create_form_attrs
      {
        title:       'New Intake Form',
        form_json:   { fields: [{ name: 'first_name', type: 'text' }] },
        customer_id: 123,
        version:     1
      }
    end

    def sample_update_form_response
      { 'detail' => 'Form updated successfully', 'form_id' => FORM_ID }
    end
  end
end
