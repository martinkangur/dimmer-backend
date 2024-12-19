# start_service.rb
require_relative 'config/environment'  # Loads Rails environment

# Replace RabbitmqConsumerService with your actual class name
service = RabbitmqConsumerService.new("dimmer_queue")
# service = RabbitmqConsumerService.new("martin_test")
service.start
