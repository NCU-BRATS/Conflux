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

json.sprints do
  json.array!(@sprints) do |sprint|
    json.extract! sprint, :sequential_id, :title
  end
end

json.polls do
  json.array!(@polls) do |poll|
    json.extract! poll, :sequential_id, :title
  end
end

json.attachments do
  json.array!(@attachments) do |attachment|
    json.extract! attachment, :id, :name
  end
end
