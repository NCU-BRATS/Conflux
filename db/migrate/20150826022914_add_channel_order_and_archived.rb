class AddChannelOrderAndArchived < ActiveRecord::Migration
  def change
    add_column :channels, :order, :float, default: 0
    add_column :channels, :archived, :boolean, default: false
    Channel.all.each do |channel|
      channel.order = rand( -1165535...1165535 )
      channel.save
    end
  end
end
