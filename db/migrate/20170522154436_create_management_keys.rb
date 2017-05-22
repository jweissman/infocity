class CreateManagementKeys < ActiveRecord::Migration[5.0]
  def change
    create_table :management_keys do |t|
      t.references :space, foreign_key: true
      t.uuid :value
      t.text :description

      t.timestamps
    end
  end
end
