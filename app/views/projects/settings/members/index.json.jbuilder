json.array!(@participations) do |participation|
  json.extract! participation.user, :id, :name, :email, :title
  json.extract! participation, :project_id, :created_at, :updated_at
end
