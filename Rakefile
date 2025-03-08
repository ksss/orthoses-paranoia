# frozen_string_literal: true

require "bundler/gem_tasks"

require "rubocop/rake_task"
RuboCop::RakeTask.new

require "rake/testtask"
Rake::TestTask.new do |task|
  task.libs = %w[lib test]
  task.test_files = FileList["lib/**/*_test.rb"]
end

task default: %i[test rubocop]
