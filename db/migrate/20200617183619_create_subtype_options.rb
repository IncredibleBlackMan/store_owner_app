class CreateSubtypeOptions < ActiveRecord::Migration[6.0]
  def change
    create_table :subtype_options do |t|
      t.string :name
      t.references :subtype, null: false, foreign_key: true

      t.timestamps
    end
  end
end
