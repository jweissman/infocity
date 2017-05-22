class CreateCartograms < ActiveRecord::Migration[5.0]
  def change
    create_table :cartograms do |t|
      t.integer :structure, array: true, default: []

      t.timestamps
    end
  end
end
