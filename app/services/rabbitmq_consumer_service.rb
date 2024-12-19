# app/services/rabbitmq_consumer_service.rb
class RabbitmqConsumerService
  # Define key mapping
  KEY_MAPPING = {
    "name": "name",
    "organisation_id": nil,
    "id": "device_id",
    "uuid": "device_uuid",
    "key": "key",
    "mac": "mac",
    "sn": "serial_number",
    "category": "category",
    "product_name": "product_name",
    "product_id": "product_id",
    "product_model": "model",
    "icon": "icon",
    "mapping": "mapping",
    "ip": "ip",
    "version": "version"
  }.freeze

  def initialize(queue_name)
    @queue_name = queue_name
    @channel = RABBITMQ_CONNECTION.create_channel
    @queue = @channel.queue(@queue_name, durable: false)
    # @queue = @channel.queue(@queue_name, durable: true)
  end

  def start
    begin
      @queue.subscribe(block: true) do |delivery_info, properties, body|
        begin
          process_message(JSON.parse(body))
          # @channel.ack(delivery_info.delivery_tag)
        rescue => e
          puts "Error processing message: #{e.message}"
          # Acknowledge the message so it is not retried or left unacknowledged
          @channel.reject(delivery_info.delivery_tag, requeue: false)

          # Close the channel and break the loop on error
          @channel.close
          break
        end
      end
    rescue => e
      puts "Subscriber encountered an error: #{e.message}"
    ensure
      @channel.close if @channel.open?
    end
  end

  private

  def remap_and_filter_params(params)
    # Remap the keys
    remapped_params = params.transform_keys { |key| KEY_MAPPING[key.to_sym] || key }

    # Filter out only allowed keys
    remapped_params.slice(*Device::ALLOWED_KEYS)
  end

  def clean_name(product_name)
    # Clean product name with error handling
    return "" if product_name.nil?

    begin
      product_name.gsub(/[^\x00-\x7F]+/, "").gsub("+", " ").gsub("  ", " ").strip
    rescue => e
      Rails.logger.error("Error cleaning product name: #{e.message}")
    end
  end

  def process_message(message)
    begin

      payload = message["payload"] || { "dps" => {} }
      device = Device.find_or_create_by(device_id: message["device_id"])

      Rails.logger.info("Received message from: #{device['device_id']}")

      puts "Received message from: #{device['device_id']} - #{payload}"

      # Remap parameters with logging
      params = begin
        remap_and_filter_params(payload)
      rescue => e
        Rails.logger.error("Error in remapping parameters: #{e.message}")
        {}
      end

      params["product_name"] = clean_name(params["product_name"])


      # Update device with error handling
      begin
        device.update(params)
      rescue => e
        Rails.logger.error("Error updating device: #{e.message}")
      end

      # Parse sensor timestamp with error handling
      published_at = begin
      payload["t"].present? ? Time.at(payload["t"]) : nil
      rescue => e
        Rails.logger.error("Error parsing sensor timestamp: #{e.message}")
        nil
      end

      # Process each sensor value with error handling
      begin
        payload["dps"].each do |key, value|
          begin
            code = if device.mapping.dig(key.to_s, "code").present?
              device.mapping[key.to_s]["code"]
            elsif Device::EXTRA_DPS_MAPPINGS[key.to_i]&.dig(:code).present?
              Device::EXTRA_DPS_MAPPINGS[key.to_i][:code]
            else
              "no_code"  # Fallback code if neither source has a valid code
            end
            Rails.logger.info("Updating sensor #{device.name}: #{code} to value #{value}")
            # d.device_sensors.create(code: code, value: value.to_s, published_at: published_at)
            device.dps[code] = value
            # Rails.logger.info(device.dps)
            # device.save!
          rescue => e
            Rails.logger.error("Error processing sensor data for key #{key}: #{e.message}")
          end
        end
      rescue => e
        Rails.logger.error("Error looping sensor dps values #{sensor_values}: #{e.message}")
      end
      device.save


    rescue => e
      Rails.logger.error("Error processing message: #{e.message}")
    end
  end
end
