json.extract! @form.model, :id, :content, :html, :updated_at, :created_at
json.user do
  json.extract! @form.model.user, :id, :name, :email, :slug
end
