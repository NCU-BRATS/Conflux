class AddSequentialIdToChannels < ActiveRecord::Migration
  def self.up
    add_column :channels, :sequential_id, :integer

    Project.all.each do |project|
      counter = 1
      project.channels.each do |channel|
        channel.sequential_id = counter
        unless channel.save
          counter = 0
        end
        counter += 1
      end
    end
  end

  def self.down
    remove_column :channels, :sequential_id
  end
end
