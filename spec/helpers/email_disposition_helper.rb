# frozen_string_literal: true

module Helpers
  module EmailDispositionHelper
    def multi_recipient_delivered
      '{"sourceTrackingId":"7bbd40cf-fd30-4e20-b68f-f3d690d5c273","data":{"message":{"id":"<599c82da-7ddd-40a3-8cb3-cfd86f468dd3@paubox.net>","message_deliveries":[{"recipient":"hi@test.com","status":{"deliveryStatus":"delivered","deliveryTime":"Thu, 19 Apr 2018 15:48:18 -0700"}},{"recipient":"hi2@test.com","status":{"deliveryStatus":"delivered","deliveryTime":"Thu, 19 Apr 2018 15:48:18 -0700"}}]}}}'
    end

    def single_recipient_delivered
      '{"sourceTrackingId":"7bbd40cf-fd30-4e20-b68f-f3d690d5c273","data":{"message":{"id":"<599c82da-7ddd-40a3-8cb3-cfd86f468dd3@paubox.net>","message_deliveries":[{"recipient":"hi@test.com","status":{"deliveryStatus":"delivered","deliveryTime":"Thu, 19 Apr 2018 15:48:18 -0700","openedStatus":"opened","openedTime":"Thu, 19 Apr 2018 15:50:10 -0700"}}]}}}'
    end

    def error_invalid_access_token
      '{"errors":[{"code":401,"status":"invalid_access_token","title":"Invalid Access Token","details":"Access token is missing or does not match endpoint username"}]}'
    end

    def error_message_not_found
      '{"errors":[{"code":404,"status":"message_not_found","title":"Message was not found","details":"Message with this tracking id was not found"}],"sourceTrackingId":"aca95af8-9b37-450b-94c9-5fda35348b49"}'
    end
  end
end
