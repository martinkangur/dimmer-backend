class AddInventoryLabelToDevices < ActiveRecord::Migration[7.2]
  def change
    add_column :devices, :inventory_label, :string
  end
end
