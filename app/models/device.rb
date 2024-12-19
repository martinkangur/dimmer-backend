class Device < ApplicationRecord
  has_many :device_alerts
  belongs_to :organisation

  ALLOWED_KEYS = %w[name organisation_id device_id device_uuid key mac serial_number category product_name product_id product_model icon mapping ip version].freeze

  EXTRA_DPS_MAPPINGS = {
    101 => { 'code': "noise_detection", 'v': "normal" },
    102 => { 'code': "main_power_supply", 'v': "OPEN" }
  }

  # Just test method for sending random device data to rabbit
  def test_publish
    channel = RABBITMQ_CONNECTION.create_channel
    q = channel.queue("martin_test", durable: true)
    j = '{"name": "C109.1", "id": "bf43be7e0d1c3c4de9aejy", "key": "As$TGas}y;uaTxD}", "mac": "4c:a9:19:e4:8b:58", "uuid": "5c02eba83c8c9e09", "sn": "100150447000F6", "category": "pm2.5", "product_name": "AJ-662电子烟+CO2+温湿度+noise+静音", "product_id": "h10dveqhrmevi5sm", "biz_type": 0, "model": "", "sub": false, "icon": "https://images.tuyaeu.com/smart/icon/ay1545287044751gANi2/75b96dab850d91d58744064c6346bfbb.png", "mapping": {"1": {"code": "pm25_state", "type": "Enum", "values": {"range": ["alarm", "normal"]}}, "2": {"code": "pm25_value", "type": "Integer", "values": {"unit": "", "min": 0, "max": 999, "scale": 0, "step": 1}}, "6": {"code": "alarm_ringtone", "type": "Enum", "values": {"range": ["1", "2"]}}, "13": {"code": "alarm_switch", "type": "Boolean", "values": {}}, "14": {"code": "battery_state", "type": "Enum", "values": {"range": ["low", "middle", "high"]}}, "17": {"code": "alarm_bright", "type": "Integer", "values": {"unit": "", "min": 0, "max": 100, "scale": 0, "step": 25}}, "18": {"code": "temp_current", "type": "Integer", "values": {"unit": "°C", "min": -400, "max": 2000, "scale": 0, "step": 1}}, "19": {"code": "humidity_value", "type": "Integer", "values": {"unit": "%", "min": 0, "max": 100, "scale": 0, "step": 1}}, "22": {"code": "co2_value", "type": "Integer", "values": {"unit": "ppm", "min": 0, "max": 10000, "scale": 0, "step": 1}}}, "ip": "10.18.82.30", "version": "3.3", "data": {"dps": {"1": "normal", "2": 0, "4": false, "6": "2", "13": false, "14": "high", "17": 0, "18": 24, "19": 36, "22": 533, "101": "normal", "102": "OPEN"}}, "timestamp": "2024-11-05T17:32:57.201472"}'
    q.publish(j)
  end
end
