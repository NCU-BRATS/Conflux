class CreateProjectRelatedModels < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.text :description

      t.timestamps
    end

    create_table :users_projects do |t|
      t.references :user
      t.references :project

      t.timestamps
    end

    create_table :issues do |t|
      t.string :title
      t.integer :sequential_id
      t.string :status
      t.references :project
      t.references :user
      t.references :sprint
      t.timestamp :begin_at
      t.timestamp :due_at

      t.timestamps
    end

    create_table :users_issues do |t|
      t.references :user
      t.references :issue

      t.timestamps
    end

    create_table :sprints do |t|
      t.string :title
      t.integer :sequential_id
      t.string :status
      t.references :project
      t.references :user
      t.timestamp :begin_at
      t.timestamp :due_at

      t.timestamps
    end

    create_table :comments do |t|
      t.text :content
      t.references :user
      t.references :commentable, polymorphic: true

      t.timestamps
    end

    create_table :repositories do |t|
      t.string :name
      t.string :link
      t.references :project

      t.timestamps
    end

    create_table :groups do |t|
      t.string :name
      t.text :description
      t.integer :leader_id

      t.timestamps
    end

    create_table :users_groups do |t|
      t.references :user
      t.references :group

      t.timestamps
    end
  end
end
