json.array!(@events) do |event|
  json.extract! event, :id, :target_type, :target_json, :action, :created_at
  json.author do
    json.extract! event.author, :id, :name, :email, :slug
  end
end
