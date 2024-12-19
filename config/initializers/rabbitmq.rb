
# config/initializers/rabbitmq.rb
require "bunny"

# Establish a connection to RabbitMQ
RABBITMQ_CONNECTION = Bunny.new(
  host: "212.47.220.156",
  username: "development",
  password: "PBpkgkoxa!Bxa!86J7_C",
  vhost: "development"

)

RABBITMQ_CONNECTION.start
