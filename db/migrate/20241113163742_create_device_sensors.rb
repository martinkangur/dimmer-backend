class CreateDeviceSensors < ActiveRecord::Migration[7.2]
  def change
    create_table :device_sensors, id: :uuid do |t|
      t.references :device, null: false, foreign_key: true, type: :uuid, index: true
      t.string :alarm_bright
      t.string :humidity_value
      t.string :alarm_ringtone
      t.string :no_code
      t.string :alarm_switch
      t.string :main_power_supply
      t.string :temp_current
      t.string :noise_detection
      t.string :co2_value
      t.string :pm25_value
      t.string :pm25_state
      t.string :battery_state
      t.timestamp :published_at
      t.timestamps
    end
  end
end
