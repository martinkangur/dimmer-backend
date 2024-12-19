class CreateDeviceAlerts < ActiveRecord::Migration[7.2]
  def change
    create_table :device_alerts, id: :uuid do |t|
      t.uuid :device_id
      t.integer :type

      t.timestamps
    end
  end
end
