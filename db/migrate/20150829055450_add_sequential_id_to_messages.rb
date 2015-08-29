class AddSequentialIdToMessages < ActiveRecord::Migration
  def self.up
    add_column :messages, :sequential_id, :integer

    Channel.all.each do |channel|
      counter = 1
      channel.messages.each do |message|
        message.sequential_id = counter
        unless message.save
          counter = 0
        end
        counter += 1
      end
    end
  end

  def self.down
    remove_column :messages, :sequential_id
  end
end
