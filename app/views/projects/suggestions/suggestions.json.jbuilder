json.members do
  json.array!(@members) do |member|
    json.extract! member, :id, :name
  end
end

json.issues do
  json.array!(@issues) do |issue|
    json.extract! issue, :sequential_id, :title
  end
end
