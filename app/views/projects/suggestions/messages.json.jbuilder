json.messages do
  json.array!(@messages) do |message|
    json.extract! message, :id, :sequential_id, :content
  end
end