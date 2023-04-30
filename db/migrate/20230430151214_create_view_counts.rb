class CreateViewCounts < ActiveRecord::Migration[6.1]
  def change
    create_table :view_counts do |t|
      t.integer :count, default: 0
      t.integer :book_id
      t.timestamps
    end
  end
end
