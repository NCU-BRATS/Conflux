json.extract! issue, :id, :title, :sequential_id, :status, :begin_at, :due_at,  :created_at, :updated_at, :order, :point, :memo, :memo_html

json.user do
  json.partial! 'users/user', user: issue.user
end

json.assignee do
  if issue.assignee.present?
    json.partial! 'users/user', user: issue.assignee
  else
    json.null!
  end
end

json.sprint do
  if issue.sprint.present?
    json.partial! 'projects/sprints/sprint', sprint: issue.sprint
  else
    json.null!
  end
end

json.labels issue.labels do |label|
  json.id label.id
  json.title label.title
  json.color label.color
end