class AddAttachmentImageToPois < ActiveRecord::Migration
  def self.up
    change_table :pois do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :pois, :image
  end
end
