class AddPoiToComments < ActiveRecord::Migration
  def change
    remove_reference :comments, :post
    add_reference :comments, :poi, index: true
  end
end
