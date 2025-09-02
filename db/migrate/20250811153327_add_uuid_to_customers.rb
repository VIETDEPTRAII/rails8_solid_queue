class AddUuidToCustomers < ActiveRecord::Migration[8.0]
  def change
    add_column :customers, :uuid, :uuid, default: 'gen_random_uuid()', null: false
  end
end
