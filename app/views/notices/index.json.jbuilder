json.array!(@notices) do |notice|
  json.extract! notice, :id, :target_type, :target_json, :action, :state, :mode, :created_at
  json.author do
    json.extract! notice.author, :id, :name, :email, :slug
  end
  json.project do
    json.extract! notice.project, :id, :name, :slug
  end
end
