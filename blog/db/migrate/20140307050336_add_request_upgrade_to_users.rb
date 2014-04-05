class AddRequestUpgradeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :requestedRole, :text
  end
end
