class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
    	t.integer :relation_id , index: true
      t.string :relation_type
      t.text :body
      t.timestamps null: false
    end
  end
end
