module Paubox
  class EmailDisposition
    attr_reader :response, :source_tracking_id, :message_id,

    def initialize(response = {})
      @response = response
      @message_data = response.dig('data', 'message')
      @message_deliveries = @message_data.fetch('message_deliveries', [])
      @message_id = @message_data['id']
    end

    MessageDelivery = Struct.new(:recipient, :status)
    MessageDeliveryStatus = Struct.new(:delivery_status, :delivery_time,
                                       :opened_status, :opened_time)
  end
end
#
# {
#     "sourceTrackingId": "7bbd40cf-fd30-4e20-b68f-f3d690d5c273",
#     "data": {
#         "message": {
#             "id": "<599c82da-7ddd-40a3-8cb3-cfd86f468dd3@paubox.net>",
#             "message_deliveries": [
#                 {
#                     "recipient": "hi@jongreeley.com",
#                     "status": {
#                         "deliveryStatus": "delivered",
#                         "deliveryTime": "Thu, 19 Apr 2018 15:48:18 -0700"
#                     }
#                 },
#                 {
#                     "recipient": "jon.r.greeley@gmail.com",
#                     "status": {
#                         "deliveryStatus": "delivered",
#                         "deliveryTime": "Thu, 19 Apr 2018 15:48:18 -0700"
#                     }
#                 }
#             ]
#         }
#     }
# }