class AddAttachmentPoiImageToImages < ActiveRecord::Migration
  def self.up
    change_table :images do |t|
      t.attachment :poi_image
    end
  end

  def self.down
    drop_attached_file :images, :poi_image
  end
end
