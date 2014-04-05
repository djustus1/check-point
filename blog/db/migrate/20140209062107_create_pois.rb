class CreatePois < ActiveRecord::Migration
  def change
    create_table :pois do |t|
      t.string :title
      t.references :user, index: true
      t.text :description
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
