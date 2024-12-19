class DeviceAlert < ApplicationRecord
  belongs_to :device
  enum :type, smoke: 1, tamper: 2,  power: 3, noise: 4
end
