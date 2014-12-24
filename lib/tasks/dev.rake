namespace :dev do
  desc 'Rebuild system'
  task :build => %w(tmp:clear log:clear db:drop db:create db:migrate)
  task :rebuild => %w(dev:build db:seed)
end
