module Paubox
  class EmailDisposition
    require 'time'
    attr_reader :response, :message_id, :message_deliveries
    MessageDelivery = Struct.new(:recipient, :status)
    MessageDeliveryStatus = Struct.new(:delivery_status, :delivery_time,
                                       :opened_status, :opened_time)
    MessageMultiDeliveryStatus = Struct.new(:delivery_status, :delivery_time)

    def initialize(response)
      @response = response
      @message_data = response.dig('data', 'message')
      @message_deliveries ||= message_deliveries
      @message_id = @message_data['id']
    end

    def message_deliveries
      deliveries = @message_data.fetch('message_deliveries', [])
      deliveries.map do |delivery|
        status = build_message_delivery_status(delivery['status'])
        MessageDelivery.new(delivery['recipient'], status)
      end
    end

    private

    def build_message_delivery_status(stat)
      delivery_status = stat['deliveryStatus']
      delivery_time = stat['deliveryTime'].to_s.empty? ? nil : DateTime.parse(stat['deliveryTime'])
      opened_status = stat['openedStatus'].to_s.empty? ? 'unopened' : stat['openedStatus']
      opened_time = stat['openedTime'].to_s.empty? ? nil : DateTime.parse(stat['openedTime'])
      return MessageMultiDeliveryStatus.new(delivery_status, delivery_time) if multi_recipient?
      MessageDeliveryStatus.new(delivery_status, delivery_time, opened_status, opened_time)
    end

    def multi_recipient?
      @message_data.fetch('message_deliveries', []).length > 1
    end
  end
end
