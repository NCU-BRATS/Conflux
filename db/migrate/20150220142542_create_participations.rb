class CreateParticipations < ActiveRecord::Migration
  def change
    create_table :participations do |t|
      t.references :user, index: true
      t.references :participable, polymorphic: true, index: true
      t.boolean :subscribed, default: true
      t.timestamps
    end
  end
end
