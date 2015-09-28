json.array!(@messages) do |message|
  json.extract! message, :id, :content, :html, :updated_at, :created_at, :sequential_id
  json.user do
    json.extract! message.user, :id, :name, :email, :slug
  end
end
