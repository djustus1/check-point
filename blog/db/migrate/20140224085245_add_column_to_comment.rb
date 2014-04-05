class AddColumnToComment < ActiveRecord::Migration
  def change
    add_column :comments, :approved, :boolean
    add_reference :comments, :User, index: true
  end
end
