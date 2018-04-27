module Paubox
  # Parses email dispositions from /v1/message_reciept response to friendly Ruby
  class EmailDisposition
    require 'time'
    attr_reader :response, :raw_json_response, :source_tracking_id, :message_id,
                :message_deliveries, :errors
    MessageDelivery = Struct.new(:recipient, :status)
    MessageDeliveryStatus = Struct.new(:delivery_status, :delivery_time,
                                       :opened_status, :opened_time)
    MessageMultiDeliveryStatus = Struct.new(:delivery_status, :delivery_time)
    ResponseError = Struct.new(:code, :status, :title, :details)

    def initialize(response)
      @response = response
      @raw_json_response = response.to_json
      @source_tracking_id = response.dig('sourceTrackingId')
      @message_data = response.dig('data', 'message')
      @message_id = @message_data ? @message_data['id'] : nil
      @message_deliveries ||= build_message_deliveries
      @errors ||= build_errors
    end

    def errors?
      errors.any?
    end

    def build_errors
      return [] unless response['errors']
      errors = response['errors']
      errors.map { |e| ResponseError.new(e['code'], e['status'], e['title'], e['details']) }
    end

    private

    def build_message_deliveries
      return [] unless @message_data
      deliveries = @message_data.fetch('message_deliveries', [])
      deliveries.map do |delivery|
        status = build_message_delivery_status(delivery['status'])
        MessageDelivery.new(delivery['recipient'], status)
      end
    end

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
