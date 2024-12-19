class CreateDevices < ActiveRecord::Migration[7.2]
  def change
    create_table :devices, id: :uuid do |t|
      t.string :name
      t.string :description
      t.uuid   :organisation_id
      t.string :device_id
      t.string :device_uuid
      t.string :key
      t.string :mac
      t.string :serial_number
      t.string :category
      t.string :product_name
      t.string :product_id
      t.string :product_model
      t.string :icon
      t.jsonb  :mapping, default: {}
      t.jsonb  :dps, default: {}, null: false
      t.inet   :ip
      t.string :version
      t.timestamps
    end
  end
end
