module Helpers
  module EmailDispositionHelper
    def multi_recipient_delivered
       "{\"sourceTrackingId\":\"7bbd40cf-fd30-4e20-b68f-f3d690d5c273\",\"data\":{\"message\":{\"id\":\"<599c82da-7ddd-40a3-8cb3-cfd86f468dd3@paubox.net>\",\"message_deliveries\":[{\"recipient\":\"hi@test.com\",\"status\":{\"deliveryStatus\":\"delivered\",\"deliveryTime\":\"Thu, 19 Apr 2018 15:48:18 -0700\"}},{\"recipient\":\"hi2@test.com\",\"status\":{\"deliveryStatus\":\"delivered\",\"deliveryTime\":\"Thu, 19 Apr 2018 15:48:18 -0700\"}}]}}}"
    end

    def single_recipient_delivered
      "{\"sourceTrackingId\":\"7bbd40cf-fd30-4e20-b68f-f3d690d5c273\",\"data\":{\"message\":{\"id\":\"<599c82da-7ddd-40a3-8cb3-cfd86f468dd3@paubox.net>\",\"message_deliveries\":[{\"recipient\":\"hi@test.com\",\"status\":{\"deliveryStatus\":\"delivered\",\"deliveryTime\":\"Thu, 19 Apr 2018 15:48:18 -0700\",\"openedStatus\":\"opened\",\"openedTime\":\"Thu, 19 Apr 2018 15:50:10 -0700\"}}]}}}"
    end
  end
end

# {
#     "sourceTrackingId": "7bbd40cf-fd30-4e20-b68f-f3d690d5c273",
#     "data": {
#         "message": {
#             "id": "<599c82da-7ddd-40a3-8cb3-cfd86f468dd3@paubox.net>",
#             "message_deliveries": [
#                 {
#                     "recipient": "hi@test.com",
#                     "status": {
#                         "deliveryStatus": "delivered",
#                         "deliveryTime": "Thu, 19 Apr 2018 15:48:18 -0700"
#                         "openedStatus": "opened",
#                         "openedTime": "Thu, 19 Apr 2018 15:50:10 -0700"
#                     }
#                 }
#             ]
#         }
#     }
# }