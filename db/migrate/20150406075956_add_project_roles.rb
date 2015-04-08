class AddProjectRoles < ActiveRecord::Migration
  def change
    create_table :project_roles do |t|
      t.string :name
      t.references :project, index: true

      t.timestamps
    end
  end
end
