class CreateChannelRelatedModels < ActiveRecord::Migration
  def change

    create_table :channels do |t|
      t.string :name
      t.text :description
      t.text :announcement
      t.references :project, index: true

      t.timestamps
    end

    create_table :messages do |t|
      t.text :content
      t.references :user, index: true
      t.references :channel, index: true

      t.timestamps
    end

    create_table :users_channels do |t|
      t.integer :last_read_message_id, index: true
      t.references :user, index: true
      t.references :channel, index: true

      t.timestamps
    end

  end
end
