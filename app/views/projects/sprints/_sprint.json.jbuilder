json.extract! sprint, :id, :title, :sequential_id, :status, :begin_at, :due_at,  :created_at, :updated_at, :archived, :issues_count, :statuses

json.issues_done_count sprint.issues.where(status:sprint.statuses[-1]['id']).count

json.user do
  json.partial! 'users/user', user: sprint.user
end