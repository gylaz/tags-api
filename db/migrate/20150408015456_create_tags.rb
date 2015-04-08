class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.integer :taggable_id, null: false
      t.string :taggable_type, null: false
      t.text :labels, array: true, default: [], null: false

      t.timestamps null: false
    end
  end
end
