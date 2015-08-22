json.extract! comment, :id, :content, :html, :created_at, :updated_at, :commentable_id, :commentable_type, :mentioned_list, :liked_users

json.user do
  json.partial! 'users/user', user: comment.user
end