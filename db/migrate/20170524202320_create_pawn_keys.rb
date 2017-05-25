class CreatePawnKeys < ActiveRecord::Migration[5.0]
  def change
    create_table :pawn_keys do |t|
      t.references :pawn, foreign_key: true
      t.uuid :value
      t.text :description

      t.timestamps
    end
  end
end
