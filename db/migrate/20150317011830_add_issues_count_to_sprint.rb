class AddIssuesCountToSprint < ActiveRecord::Migration
  def change
    add_column :sprints, :issues_count  , :integer, null: false, default: 0

    Chewy.strategy(:bypass)
    Sprint.all.each do |sprint|
      sprint.issues_count = sprint.issues.count
      sprint.save
    end
  end
end
