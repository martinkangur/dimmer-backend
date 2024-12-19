# start_service.rb
require_relative 'config/environment'  # Loads Rails environment

# Replace RabbitmqConsumerService with your actual class name
service = RabbitmqConsumerService.new("rails_randvere")
# service = RabbitmqConsumerService.new("martin_test")
service.start
