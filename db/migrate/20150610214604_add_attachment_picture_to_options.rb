class AddAttachmentPictureToOptions < ActiveRecord::Migration
  def self.up
    change_table :options do |t|
      t.attachment :picture
    end
  end

  def self.down
    drop_attached_file :options, :picture
  end
end
