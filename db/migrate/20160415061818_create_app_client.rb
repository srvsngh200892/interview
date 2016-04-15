class CreateAppClient < ActiveRecord::Migration
  def change
    create_table :app_clients do |t|
    	t.string :client_name
      t.string :app_key
      t.string :app_secret
      t.integer :status
      t.string :permissions
      t.string :client_details

      t.timestamps
    end
  end
end
