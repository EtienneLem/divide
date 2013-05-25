# Rubygems
require 'bundler'
Bundler.require(:development)

Bundler::GemHelper.install_tasks
require "rspec/core/rake_task"

# RSpec
task :default => :spec

desc "Run all specs"
RSpec::Core::RakeTask.new(:spec) do |task|
  task.pattern = "spec/**/*_spec.rb"
  task.rspec_opts = "--colour --format=documentation"
end
