class DropPgSearchDocuments < ActiveRecord::Migration
  def self.up
    execute 'DROP EXTENSION IF EXISTS pg_trgm;'
    execute 'DROP EXTENSION IF EXISTS fuzzystrmatch;'

    say_with_time('Dropping table for pg_search multisearch') do
      drop_table :pg_search_documents
    end
  end

  def self.down
    say_with_time('Creating table for pg_search multisearch') do
      create_table :pg_search_documents do |t|
        t.text :content
        t.belongs_to :searchable, :polymorphic => true
        t.timestamps null: false
      end
    end
    execute 'CREATE EXTENSION IF NOT EXISTS pg_trgm;'
    execute 'CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;'
  end
end
