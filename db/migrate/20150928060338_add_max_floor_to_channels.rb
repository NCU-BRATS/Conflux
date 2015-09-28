class AddMaxFloorToChannels < ActiveRecord::Migration
  def change
    add_column :channels, :max_floor, :integer, default: 0

    Channel.reset_column_information

    channels = Channel.all.each do |channel|
      message = channel.messages.last

      next if message.nil?

      channel.max_floor = message.sequential_id
      channel.save
    end
  end
end
