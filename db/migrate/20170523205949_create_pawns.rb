class CreatePawns < ActiveRecord::Migration[5.0]
  def change
    create_table :pawns do |t|
      t.references :space, foreign_key: true
      t.integer :x
      t.integer :y
      t.string :name
      t.text :status

      t.timestamps
    end
  end
end
