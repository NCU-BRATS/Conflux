class AddSequentialIdToAttachments < ActiveRecord::Migration
  def self.up
    add_column :attachments, :sequential_id, :integer

    Project.all.each do |project|
      counter = 1
      project.attachments.each do |attachment|
        attachment.sequential_id = counter
        unless attachment.save
          counter = 0
        end
        counter += 1
      end
    end
  end

  def self.down
    remove_column :attachments, :sequential_id
  end
end
