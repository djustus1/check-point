class AddParamtersToUser < ActiveRecord::Migration
  def change
    add_column :users, :about_me, :string
    add_column :users, :private_web_url, :string
    add_column :users, :first_name, :string, :null => false, :default => ""
    add_column :users, :last_name, :string, :null => false, :default => ""
  end
end
