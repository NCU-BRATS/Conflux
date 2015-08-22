class AddKanbanAttr < ActiveRecord::Migration
  def change
    add_column :sprints, :statuses, :jsonb, default: []
    add_column :issues, :order, :float, default: 0
    Issue.all.each do |issue|
      if issue.status.to_s == 'open'
        issue.status = '1'
      else
        issue.status = '2'
      end
      issue.save
    end
    Sprint.all.each do |sprint|
      sprint.statuses = [ { id:1, name:'backlog' }, { id:2, name:'done' } ]
      sprint.save
    end
  end
end
